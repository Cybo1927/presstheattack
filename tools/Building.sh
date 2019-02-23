#!/bin/bash

# Homepage: https://github.com/bogachenko/presstheattack
# Description: A slightly ugly script that collects filters. There are probably better ways to do this, but for now my little assistant is doing his job.
# License: MIT

TEMP='../src/tmp/'
SRC='../src/'

echo 'In order to collect all the filters in one list, we need a temporary folders.'
if [ ! -d $TEMP ]
then
	echo 'Creating temporary folders...'
	mkdir $TEMP
	mkdir $TEMP/{sort,dontsort}/
	sleep .5
	echo 'Folders created!'
else
     echo "Directory already exists"  
fi

echo 'Before adding to the main list, I will sort it for better convenience.'
perl ./Sorting.pl $SRC/combined.txt $SRC/dom.txt $SRC/fonts.txt $SRC/frame.txt $SRC/images.txt $SRC/other.txt $SRC/popups.txt $SRC/resources.txt $SRC/scripts.txt $SRC/servers.txt $SRC/whitelist.txt $SRC/xmlhttprequest.txt

echo 'Creating a header for the list...'
sleep .5
cat > $TEMP/headers.txt <<EOF
[Adblock Plus 2.0]
! Checksum: 0000000000000000000000
! Title: Press the Attack
! Last modified: 0000-00-00, 00:00:00
! Version: 00000000000000
! Expires: 3 hours
! Homepage: https://github.com/bogachenko/presstheattack/
! Wiki: https://github.com/bogachenko/presstheattack/wiki/
! Licence: https://raw.githubusercontent.com/bogachenko/presstheattack/master/LICENSE.md
! In no event shall this list, or the list author be liable for any indirect, direct,
! punitive, special, incidental, or consequential damages whatsoever.
! By downloading or viewing, or using this list, you are accepting these terms and the license.
!
! I'm sure a few of the filters here will break some sites.
! Please be cautious and check uBlock Origin logger to see what is being filtered,
! and comment out any problamatic filter. Or use the "badfilter" flag.
! Almost all network filters here are marked as "important" and therefore extensions
! such as Adblock Plus or others put them on a white list or not read at all due to limitations
! in the filter syntax and other reasons that do not bother me.
!
! If you use uBlock Origin then you can get help in any way convenient for you:
! E-mail - bogachenkove@gmail.com
! GitHub issues - https://github.com/bogachenko/presstheattack/issues/
! GitHub pull requests - https://github.com/bogachenko/presstheattack/pulls/
!
! The list of filters below is primarily for uBlock Origin
! Download uBlock Origin from GitHub - https://github.com/gorhill/uBlock/releases/

EOF

cp ../src/combined.txt $TEMP/sort/
cp ../src/dom.txt $TEMP/sort/
cp ../src/fonts.txt $TEMP/sort/
cp ../src/frame.txt $TEMP/sort/
cp ../src/images.txt $TEMP/sort/
cp ../src/other.txt $TEMP/sort/
cp ../src/popups.txt $TEMP/sort/
cp ../src/resources.txt $TEMP/dontsort/
cp ../src/scripts.txt $TEMP/sort/
cp ../src/servers.txt $TEMP/sort/
cp ../src/whitelist.txt $TEMP/sort/
cp ../src/xmlhttprequest.txt $TEMP/sort/
python ./FOP.py $TEMP/sort/
sort --output=$TEMP/filterlist.txt $TEMP/sort/combined.txt $TEMP/sort/dom.txt $TEMP/sort/fonts.txt $TEMP/sort/frame.txt $TEMP/sort/images.txt $TEMP/sort/other.txt $TEMP/sort/popups.txt $TEMP/dontsort/resources.txt $TEMP/sort/scripts.txt $TEMP/sort/servers.txt $TEMP/sort/whitelist.txt $TEMP/sort/xmlhttprequest.txt
cat $TEMP/headers.txt $TEMP/filterlist.txt > ../presstheattack.txt
rm -rf $TEMP

git pull
perl ./Sorting.pl ../presstheattack.txt
perl ./UpdateDateString.pl ../presstheattack.txt
perl ./AddChecksum.pl ../presstheattack.txt
git status
git commit -a -m 'Update presstheattack.txt'
git push origin master
sleep .5
echo 'Upload finished'
read -n 1 -s -r -p 'Press any key to exit.'