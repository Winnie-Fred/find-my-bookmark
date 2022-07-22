#!/usr/bin/env bash

printf "Welcome to 'find my bookmark'.\nThis tool searches for your bookmark in the following browsers: Google Chrome, Mozilla Firefox, Chromium and Brave Browser\n"

KEY_WORD=${1?Error: No keyword given. Enter in the keyword you are searching for as an argument. A sample command would be "./find-my-bookmark.sh 'example keyword'"}

check=`pgrep firefox`
if [ $? -eq 0 ]
then
	echo -e "\n"
	echo "Firefox is running. If you want any bookmarks you have added since you opened Firefox to be included in this search, close the browser. "
	read -rsn1 -p "Otherwise, Press any key to continue . . .  ";
	echo -e "\n"
fi

printf "Searching . . . \n"

> bookmarks.md # This overwrites the file if it already exists, otherwise, creates a new one and empties it.

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


GOOGLE_CHROME_DIR="$HOME/.config/google-chrome"

CHROMIUM_DIR="$HOME/.config/chromium"

BRAVE_DIR="$HOME/.config/BraveSoftware"

chromium_bookmarks_directories=($GOOGLE_CHROME_DIR $CHROMIUM_DIR $BRAVE_DIR)

for directory in ${chromium_bookmarks_directories[@]}
do
	export_chromium_browsers_bookmarks $directory
done


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
		        sqlite3 new_places.sqlite "SELECT json_object('name', IFNULL(moz_places.title , ''), 'url', IFNULL(moz_places.url , '')) FROM moz_places INNER JOIN moz_bookmarks ON moz_places.id = moz_bookmarks.fk;" | jq --arg KEY_WORD "${KEY_WORD,,}" 'with_entries(select(.key | in({"name":"", "url":""}))) | select((.name | ascii_downcase | contains($KEY_WORD)) or (.url | ascii_downcase | contains($KEY_WORD)))' >> bookmarks.md
			fi

	           
        fi 
    done 
  
fi

if [ -s bookmarks.md ]
then
	echo "Search complete. Open bookmarks.md in this directory to see the search results"
else
	echo "No bookmarks found. Try another keyword?"
fi
