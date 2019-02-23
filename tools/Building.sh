#!/bin/bash

git pull
perl ./Sorting.pl ../presstheattack.txt
perl ./UpdateDateString.pl ../presstheattack.txt
perl ./AddChecksum.pl ../presstheattack.txt
git status
git commit -a -m "Update presstheattack.txt"
git push
echo "Upload finished"
read -n 1 -s -r -p "Press any key to exit." 