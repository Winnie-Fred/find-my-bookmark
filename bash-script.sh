#!/usr/bin/env bash

printf "This tool supports the following browsers: Google Chrome, Mozilla Firefox, Chromium and Brave Browser\n"
KEY_WORD=${1?Error: No keyword given. Enter in the keyword you are searching for as an argument. A sample command would be "./bash-script.sh 'example keyword'"}

check=`ps -ef|grep firefox|grep -v grep`
if [ $? -eq 0 ]
then
	echo -e "\n"
	echo "Firefox is running. If you want any bookmarks you have added since you opened Firefox to be included in this search, close the browser. "
	read -rsn1 -p "Otherwise, Press any key to continue . . .  ";
	echo -e "\n"
fi


export_chromium_browsers_bookmarks () {
    if [ -d $1 ]
    then
            
        readarray -td '' bookmarks_dir < <(find $1 -type f \( -name 'Bookmarks' \) -print0)


        for bookmarks_dir in "${bookmarks_dir[@]}"
        do

            if [ -s "$bookmarks_dir" ]
            then		

		jq --arg KEY_WORD "${KEY_WORD,,}" '.. | objects | with_entries(select(.key | in({"name":"", "url":""}))) | select(. != {}) | select(has("url")) | select((.name | ascii_downcase | contains($KEY_WORD)) or (.url | ascii_downcase | contains($KEY_WORD)))' "$bookmarks_dir" >> bookmarks.md
          	
            fi 
        done 
    fi
}



# GOOGLE CHROME
GOOGLE_CHROME_DIR="$HOME/.config/google-chrome"
export_chromium_browsers_bookmarks $GOOGLE_CHROME_DIR


# CHROMIUM
CHROMIUM_DIR="$HOME/.config/chromium"
export_chromium_browsers_bookmarks $CHROMIUM_DIR



# BRAVE
BRAVE_DIR="$HOME/.config/BraveSoftware"
export_chromium_browsers_bookmarks $BRAVE_DIR     



# MOZILLA FIREFOX
FIREFOX_DIR="$HOME/.mozilla/firefox"
if [ -d $FIREFOX_DIR ]
then

    readarray -td '' bookmarks_dir < <(find $FIREFOX_DIR -type f \( -name 'places.sqlite' \) -print0)

    
    for bookmarks_dir in "${bookmarks_dir[@]}"
    do

        if [ -s "$bookmarks_dir" ]
        then
	    	cp "$bookmarks_dir" new_places.sqlite
			
			if [ $(sqlite3 new_places.sqlite "SELECT count(*) name FROM sqlite_master WHERE type='table' AND name='moz_bookmarks' OR name='moz_places' COLLATE NOCASE;") -eq 2 ]
			then
		        sqlite3 new_places.sqlite "SELECT json_object('name', IFNULL(moz_places.title , ''), 'url', IFNULL(moz_places.url , '')) FROM moz_places INNER JOIN moz_bookmarks ON moz_places.id = moz_bookmarks.fk;" | jq --arg KEY_WORD "${KEY_WORD,,}" '{"name" : .name, "url" : .url}  | select((.name | ascii_downcase | contains($KEY_WORD)) or (.url | ascii_downcase | contains($KEY_WORD)))' >> bookmarks.md
			fi
			           
        fi 
    done 
  
fi
