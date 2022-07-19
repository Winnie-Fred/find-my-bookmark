# find-my-bookmark

### A simple bash script for Linux to search for a bookmark among all your bookmarks in Google Chrome, Chromium, Brave and Mozilla Firefox Browsers 

#### About the Project

If you use different browsers, your bookmarks are most likely stored across all of them. This may make it difficult to look for one especially if you do not remember which particular browser stores that bookmark. This bash script lets you search through all the bookmarks of the four major browsers mentioned above.

#### Why find-my-bookmark? Why shell scripting?
Shell scripting is used because I wanted to try my hands on an actual project after watching a Bash script crash course video. I chose this project to learn more about Linux and shell scripting. 

#### Possible Update
Currently, the results of the bookmarks search are appended to a markdown file. A future feature I hope to implement is to add Rofi to the project to give it a simple and minimalist GUI interface.
 
#### Dependencies
- bash v4.4.0+
- jq v1.5+
- sqlite3 v3.29.0+

You can check if you have the right dependencies with `bash --version`, `jq --version` or `sqlite3 --version`<br>


#### How to run the project
You can use find-my-bookmark locally on your computer by following these steps:
- Install and ensure you have the right dependencies
- cd into the directory of the script and make it executable with `chmod u+x find-my-bookmark.sh`
- Enter `./find-my-bookmark.sh <keyword>` to find your bookmark, where "keyword" is the word or words in the bookmark you are searching for. For example: `./find-my-bookmark.sh "example keyword"`

#### Tip
If you are searching for more than one word, wrap them in quotes like this: `./find-my-bookmark.sh "find my bookmark"` instead of this: `./find-my-bookmark.sh find my bookmark`. The latter will only look for the first word, "find".

***Note: This script only searches Google Chrome, Chromium, Brave and Mozilla Firefox Browsers. It will only find bookmarks on various Linux distributions only***.

#### Credits and Inspiration
This project is inspired by the bookmarks keeper project on Crio at crio.do [here](https://www.crio.do/projects/bash-bookmarks-keeper/)

