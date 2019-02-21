#!/bin/bash

git pull
perl ./sorting.pl ../presstheattack.txt
perl ./addChecksum.pl ../presstheattack.txt
perl ./updateDateString.pl ../presstheattack.txt
git status
git commit -a -m "Update presstheattack.txt"
git push
read -n 1 -s -r -p "Press any key to exit." 