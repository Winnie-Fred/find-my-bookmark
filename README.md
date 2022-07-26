# find-my-bookmark

### A simple bash script for Linux to search for a bookmark among all your bookmarks scattered across various browsers.

#### About the Project

If you use different browsers, your bookmarks are most likely stored across all of them. This may make it difficult to look for one, especially if you do not remember which particular browser stores that bookmark. This bash script helps you do just that.

#### Why find-my-bookmark? Why shell scripting?
I used shell scripting because I wanted to try my hands on an actual project after watching a bash script crash course video. I chose this project to learn more about Linux and automating tasks with shell scripting. 

#### Supported Browsers
This script searches only these browsers for bookmarks:
- Google Chrome Browser
- Chromium Browser
- Brave Browser
- Mozilla Firefox Browser

 
#### Dependencies
- bash v4.4.0+
- jq v1.5+
- sqlite3 v3.29.0+
- dmenu v4.5+ (Optional)
- rofi (Optional)

You can check if you have the right dependencies with `bash --version`, `jq --version`, `sqlite3 --version`, `dmenu -v` or `rofi --version`


#### How to run the project
You can use find-my-bookmark locally on your computer by following these steps:
- Install and ensure you have the right dependencies
- cd into the directory of the script and make it executable with `chmod u+x find-my-bookmark.sh`
- Enter `./find-my-bookmark.sh --search=[SEARCH]` to find your bookmark, where "SEARCH" is the keyword or keywords in the name or url of the bookmark you are searching for. For example: `./find-my-bookmark.sh --search="example keyword"`
- To fetch all bookmarks without filtering, enter `./find-my-bookmark.sh --show-all`


#### Tips
- If you are searching for more than one word, wrap them in quotes like this: `./find-my-bookmark.sh --search="find my bookmark"` instead of this: `./find-my-bookmark.sh --search=find my bookmark`.
- If you want a GUI interface to interact with the script with, install dmenu and run the program with the dmenu flag like so instead: `./find-my-bookmark.sh --search="example keyword" -dmenu` or `./find-my-bookmark.sh --show-all -dmenu`
- If you prefer rofi, install it and run the script with the rofi flag like so: `./find-my-bookmark.sh --search="example keyword" -rofi` or `./find-my-bookmark.sh --show-all -rofi`
- Get help with the -h or --help flag with this command: `./find-my-bookmark.sh -h` or `./find-my-bookmark.sh --help`
- If you love this tool, and you use it often, and you want to be able to access it from anywhere, consider adding it to your PATH.

***Note: This script only searches Google Chrome, Chromium, Brave and Mozilla Firefox Browsers. It will only find bookmarks on various Linux distributions only (preferably those installed with a GUI)***.

#### Credits and Inspiration
This project is inspired by the bookmarks keeper project on Crio at crio.do [here](https://www.crio.do/projects/bash-bookmarks-keeper/)

