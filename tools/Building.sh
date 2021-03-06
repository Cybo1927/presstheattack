#!/bin/bash

# Homepage: https://github.com/bogachenko/presstheattack
# Description: A slightly ugly script that collects filters. There are probably better ways to do this, but for now my little assistant is doing his job.
# License: MIT

TEMP='../src/tmp/'
SRC='../src/'
DATE=$(date '+%Y-%m-%d %H:%M:%S')
VERSION=$(date '+%Y%m%d%H%M%S')

echo 'Updating the filter lists...'
git pull
git status
git commit -a -m 'Update for filter lists'
echo 'In order to collect all the filters in one list, we need a temporary folders.'
if [ ! -d $TEMP ]
then
	echo 'Creating temporary folder...'
	mkdir $TEMP
	sleep .5
	echo 'Folder created!'
else
echo 'Directory already exists'  
fi
python FOP.py $SRC
cp $SRC/combined.txt $TEMP
cp $SRC/frame.txt $TEMP
cp $SRC/images.txt $TEMP
cp $SRC/other.txt $TEMP
cp $SRC/popups.txt $TEMP
cp $SRC/scripts.txt $TEMP
cp $SRC/servers.txt $TEMP
cp $SRC/xmlhttprequest.txt $TEMP
sort --output=$TEMP/filterlist.txt $TEMP/combined.txt $TEMP/frame.txt $TEMP/images.txt $TEMP/other.txt $TEMP/popups.txt $TEMP/scripts.txt $TEMP/servers.txt $TEMP/xmlhttprequest.txt
echo 'Creating a header for the list...'
LINES=$(grep -c '' $TEMP/filterlist.txt)
cat > $TEMP/headers.txt <<EOF
! Title: Press the Attack
! Description: Filters for ad blocking, tracking, crypto mining, and more!
! Last modified: ${DATE}
! Version: ${VERSION}
! Expires: 3 hours
! Number of filters: ${LINES}
! Homepage: https://github.com/bogachenko/presstheattack/
! Licence: https://raw.githubusercontent.com/bogachenko/presstheattack/master/LICENSE.md
!
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
! The list of filters below is primarily for uBlock Origin
! Download uBlock Origin from GitHub - https://github.com/gorhill/uBlock/releases/

EOF
perl ./Sorting.pl $TEMP/filterlist.txt
cat $TEMP/headers.txt $TEMP/filterlist.txt > ../presstheattack.txt
echo 'Delete temporary files...'
rm -rf $TEMP
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
echo 'Upload finished'
read -n 1 -s -r -p 'Press any key to exit.'