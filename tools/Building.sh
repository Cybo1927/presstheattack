#!/bin/bash

# Homepage: https://github.com/bogachenko/presstheattack
# Description: A slightly ugly script that collects filters. There are probably better ways to do this, but for now my little assistant is doing his job.
# License: MIT

TEMP='../src/tmp/'
SRC='../src/'
DATE=$(date '+%Y-%m-%d %H:%M:%S')
VERSION=$(date '+%Y%m%d%H%M%S')

echo 'In order to collect all the filters in one list, we need a temporary folders.'
if [ ! -d $TEMP ]
then
	echo 'Creating temporary folders...'
	mkdir $TEMP
	mkdir $TEMP/{sort,dontsort}/
	sleep .5
	echo 'Folders created!'
else
     echo 'Directory already exists'  
fi

sleep .5

echo 'Now I will copy the filters to a temporary folder...'
cp $SRC/combined.txt $TEMP/sort/
cp $SRC/dom.txt $TEMP/sort/
cp $SRC/frame.txt $TEMP/sort/
cp $SRC/images.txt $TEMP/sort/
cp $SRC/other.txt $TEMP/sort/
cp $SRC/popups.txt $TEMP/sort/
cp $SRC/resources.txt $TEMP/dontsort/
cp $SRC/scripts.txt $TEMP/sort/
cp $SRC/servers.txt $TEMP/sort/
cp $SRC/whitelist.txt $TEMP/sort/
cp $SRC/xmlhttprequest.txt $TEMP/sort/
sleep .5
python ./FOP.py $TEMP/sort/

sort --output=$TEMP/filterlist.txt $TEMP/sort/combined.txt $TEMP/sort/dom.txt $TEMP/sort/frame.txt $TEMP/sort/images.txt $TEMP/sort/other.txt $TEMP/sort/popups.txt $TEMP/dontsort/resources.txt $TEMP/sort/scripts.txt $TEMP/sort/servers.txt $TEMP/sort/whitelist.txt $TEMP/sort/xmlhttprequest.txt

echo 'Creating a header for the list...'
sleep .5
LINES=$(grep -c '' $TEMP/filterlist.txt)
cat > $TEMP/headers.txt <<EOF
[Adblock Plus 2.0]
! Title: Press the Attack
! Last modified: ${DATE}
! Version: ${VERSION}
! Expires: 3 hours
! Number of filters: ${LINES}
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

perl ./Sorting.pl $TEMP/filterlist.txt
cat $TEMP/headers.txt $TEMP/filterlist.txt > ../presstheattack.txt

echo 'Delete temporary files and folders...'
sleep .5
rm -rf $TEMP
sleep .1
echo 'Deletion complete!'

echo 'Do you want to send modified files to Git (y/N)?'
select yn in "Yes" "No"; do
	case $yn in
		Yes )
		git pull
		git status
		git commit -a -m 'Update presstheattack.txt'
		git push origin master;
		break
		;;
		No )
		exit
		;;
    esac
done

sleep .5
echo 'Upload finished'
read -n 1 -s -r -p 'Press any key to exit.'