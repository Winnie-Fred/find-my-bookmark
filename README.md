# find-my-bookmark

### A simple bash script for Linux to search for a bookmark among all your bookmarks.

#### About the Project

If you use different browsers, your bookmarks are most likely stored across all of them. This may make it difficult to look for one especially if you do not remember which particular browser stores that bookmark. This bash script lets you search through all the bookmarks of the four major browsers mentioned above.

#### Why find-my-bookmark? Why shell scripting?
Shell scripting is used because I wanted to try my hands on an actual project after watching a Bash script crash course video. I chose this project to learn more about Linux and shell scripting. 

#### Supported Browsers
This script searches only these browsers:
- Google Chrome Browser
- Chromium Browser
- Brave Browser
- Mozilla Firefox Browser

#### Possible Update
Currently, the results of the bookmarks search are appended to a markdown file and can optionally be displayed with dmenu. A future feature I hope to implement is to add an option for rofi to the project for those who prefer it to dmenu.
 
#### Dependencies
- bash v4.4.0+
- jq v1.5+
- sqlite3 v3.29.0+
- dmenu v4.5+ (Optional)

You can check if you have the right dependencies with `bash --version`, `jq --version`, `sqlite3 --version`<br> or `dmenu -v`


#### How to run the project
You can use find-my-bookmark locally on your computer by following these steps:
- Install and ensure you have the right dependencies
- cd into the directory of the script and make it executable with `chmod u+x find-my-bookmark.sh`
- Enter `./find-my-bookmark.sh --search=[SEARCH]` to find your bookmark, where "SEARCH" is the keyword or keywords in the name or url of the bookmark you are searching for. For example: `./find-my-bookmark.sh --search="example keyword"`
- If you want a GUI interface to interact with the script with, install dmenu and run the program with the dmenu flag like so instead: `./find-my-bookmark.sh --search="example keyword" -dmenu`

#### Tip
If you are searching for more than one word, wrap them in quotes like this: `./find-my-bookmark.sh --search="find my bookmark"` instead of this: `./find-my-bookmark.sh --search=find my bookmark`.

***Note: This script only searches Google Chrome, Chromium, Brave and Mozilla Firefox Browsers. It will only find bookmarks on various Linux distributions only (preferably those installed with a GUI)***.

#### Credits and Inspiration
This project is inspired by the bookmarks keeper project on Crio at crio.do [here](https://www.crio.do/projects/bash-bookmarks-keeper/)

