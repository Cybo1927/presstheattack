#!/bin/bash
git pull
perl ./addChecksum.pl ../presstheattack.txt
git status
git commit -a -m "Update presstheattack.txt"
git push