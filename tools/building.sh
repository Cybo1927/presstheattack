#!/bin/bash

## This file is part of the Press the Attack project,
## Copyright (c) 2019 Bogachenko Vyacheslav
##
## Press the Attack is a free project: you can distribute it and/or modify
## it in accordance with the MIT license published by the Massachusetts Institute of Technology.
##
## The Press the Attack project is distributed in the hope that it will be useful,
## and is provided "AS IS", WITHOUT ANY WARRANTY, EXPRESSLY EXPRESSED OR IMPLIED.
## WE ARE NOT RESPONSIBLE FOR ANY DAMAGES DUE TO THE USE OF THIS PROJECT OR ITS PARTS.
## For more information, see the MIT license.
##
## Github: https://github.com/bogachenko/presstheattack/
## Last modified: February 11, 2019
## License: MIT <https://github.com/bogachenko/presstheattack/blob/master/LICENSE.md>
## Problem reports: https://github.com/bogachenko/presstheattack/issues
## Title: building.sh
## URL: https://raw.githubusercontent.com/bogachenko/presstheattack/master/tools/building.sh
## Wiki: https://github.com/bogachenko/presstheattack/wiki
##
## Download the entire Press the Attack project at https://github.com/bogachenko/presstheattack/archive/master.zip

date=$(date '+%H:%M:%S %Z %Y-%m-%d')
echo "Getting started in:" $date
git pull
perl ./addChecksum.pl ../presstheattack.txt
perl ./updateDateString.pl ../presstheattack.txt
git status
git commit -a -m "Update presstheattack.txt"
git push
echo "Work completed in:" $date
read -n 1 -s -r -p "Press any key to exit." 