#!/usr/bin/env bash

printf "Welcome to 'find my bookmark'.\n"

display_help() {
	echo
	printf "A script to search for your bookmark in the following browsers: Google Chrome, Mozilla Firefox, Chromium and Brave Browser.\n\n"
	echo "Usage: "$0" --search=[SEARCH] [-dmenu] [-h | --help]"
	echo
	echo "where:"
	echo "    --search=SEARCH        SEARCH is the keyword or keywords contained in the name or url of the bookmark you are searching for"
	echo
	echo "Optional:"	
	echo "    -dmenu                 shows the bookmarks that match the search in a menu with dmenu"
	echo "    -rofi                  shows the bookmarks that match the search in a menu with rofi"
	echo "    -h | --help            shows this help text and exits"
	echo
	echo "Tip: Enclose 'SEARCH' in quotes especially if it contains space(s)"	
}


while test $# -gt 0; do
  case "$1" in
    -h|--help) display_help; exit 0; ;;
	-dmenu)
	  export with_dmenu=true
	  shift
      ;;
	-rofi)
	  export with_rofi=true
	  shift
      ;;
    --search*)
	  if [[ $1 == *"="* ]]
	  # Only tries to get the value of the --search option if $1 != "--search" as string manipulation on $1 
      # would return "--search" because there is no "=" character
	  then
		  export KEY_WORD=`echo ${1#*=}`
	  else
		  unset KEY_WORD
      fi;
      shift
      ;;
    *) echo "Unknown parameter or option passed: '"$1"'"; display_help; exit 0;

      ;;
  esac
done


# This exits and prints an error when the keyword is an empty string, a space or spaces. 
# No check for tabs or any other type of whitespace is done as they are treated as strings
# since they may be valid searches such as "\t" 
# e.g. "regex - What is the difference between \\s and \\t? - Stack Overflow" is a valid bookmark name


KEY_WORD=${KEY_WORD?"Error: No keyword given. $(display_help)"}

if [[ -z "${KEY_WORD// }" ]]
then
	echo "$0: line ${LINENO}: Error: Invalid input. Search must contain characters other than space";
	exit 1
fi


check=`pgrep firefox`
if [ $? -eq 0 ]
then
	echo -e "\n"
	echo "Firefox is running. If you want any bookmarks you have added since you opened Firefox to be included in this search, close the browser. "
	read -rsn1 -p "Otherwise, Press any key to continue . . .  ";
	echo -e "\n"
fi

echo "Searching for '"${KEY_WORD}"' . . ."
echo -e "\n"

> bookmarks.md  # This overwrites the file if it already exists, otherwise, creates a new one and empties it.

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

# Open bookmarks.md or open dmenu with list of bookmarks if at least one match was found
if [ -s bookmarks.md ]
then
	if [ "$with_dmenu" = true ] || [ "$with_rofi" = true ]
	then

		readarray -t name_array < <(cat bookmarks.md | jq -r '.name')
		readarray -t url_array < <(cat bookmarks.md | jq -r '.url')

		declare -a options

		for i in "${!name_array[@]}"
		do
			if ! [[ ${name_array[i]} ]]
			then
				options+=("${url_array[i]}")
			else
				options+=("${name_array[i]}   ====>   ${url_array[i]}")
			fi
		done

		options+=("quit")

		echo "Search complete. Choose your bookmark from the menu or open bookmarks.md in this directory to see the search results"

		if [ "$with_dmenu" = true ]
		then
			choice=$(printf '%s\n' "${options[@]}" | dmenu -i -l 40 -p "Select bookmark")
		elif [ "$with_rofi" = true ]
		then
			choice=$(printf '%s\n' "${options[@]}" | rofi -dmenu -i -l 40 -p "Select bookmark")
		fi

		if [[ "$choice" == quit ]]
		then
			echo "Program terminated." && exit 1
		elif [ "$choice" ]
		then
			cfg=$(printf '%s\n' "${choice}" | awk '{print $NF}')
			xdg-open "$cfg" &  # Opens url with default browser as background process
		else
			echo "Program terminated." && exit 1
		fi
	else

		echo "Search complete. Check bookmarks.md in this directory for the search results"
		xdg-open bookmarks.md  # Opens file with default text editor
	fi
else
	echo "No bookmarks found. Check your spelling. You could also try different or more general keywords"
fi

