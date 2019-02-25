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
	sleep .5
	echo 'Folders created!'
else
     echo "Directory already exists"  
fi

echo 'Now I will copy the filters to a temporary folder...'
sleep 3
cp $SRC/combined.txt $TEMP
cp $SRC/dom.txt $TEMP
cp $SRC/frame.txt $TEMP
cp $SRC/images.txt $TEMP
cp $SRC/other.txt $TEMP
cp $SRC/popups.txt $TEMP
cp $SRC/resources.txt $TEMP
cp $SRC/scripts.txt $TEMP
cp $SRC/servers.txt $TEMP
cp $SRC/whitelist.txt $TEMP
cp $SRC/xmlhttprequest.txt $TEMP
sleep .5

echo 'Error correction in progress...'
sleep 3
python ./FOP.py $TEMP
sed -i "s/## + js/##+js/g" $TEMP/resources.txt
sed -i "s/math.random/Math.random/g" $TEMP/resources.txt
sed -i "s/element.prototype/Element.prototype/g" $TEMP/resources.txt

echo 'Copying the corrected filters to the "src" folder...'
sleep 3
cp $TEMP/combined.txt $SRC
cp $TEMP/dom.txt $SRC
cp $TEMP/frame.txt $SRC
cp $TEMP/images.txt $SRC
cp $TEMP/other.txt $SRC
cp $TEMP/popups.txt $SRC
cp $TEMP/resources.txt $SRC
cp $TEMP/scripts.txt $SRC
cp $TEMP/servers.txt $SRC
cp $TEMP/whitelist.txt $SRC
cp $TEMP/xmlhttprequest.txt $SRC
sleep .5

sort --output=$TEMP/filterlist.txt $TEMP/combined.txt $TEMP/dom.txt $TEMP/frame.txt $TEMP/images.txt $TEMP/other.txt $TEMP/popups.txt $TEMP/resources.txt $TEMP/scripts.txt $TEMP/servers.txt $TEMP/whitelist.txt $TEMP/xmlhttprequest.txt

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

cat $TEMP/headers.txt $TEMP/filterlist.txt > ../presstheattack.txt

echo 'Delete temporary files and folders...'
sleep .5
rm -rf $TEMP
sleep .1
echo 'Deletion complete!'

#git pull
perl ./Sorting.pl ../presstheattack.txt
perl ./UpdateDateString.pl ../presstheattack.txt
perl ./AddChecksum.pl ../presstheattack.txt
#git status
#git commit -a -m 'Update presstheattack.txt'
#git push origin master
sleep .5
echo 'Upload finished'
read -n 1 -s -r -p 'Press any key to exit.'