#!/bin/bash
git pull
perl ./addChecksum.pl ../presstheattack.txt
git commit -m "Update presstheattack.txt"
git push