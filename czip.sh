#!/bin/bash
# Zip all .c and .h files in a directory into a file named DIRECTORY.zip

ASSGN=${PWD##*/}


if /home/jhuynh42/357/Scripts/stylecheck.sh | grep 'FAILED' &> /dev/null; then
   echo "Failed stylecheck!"
   exit 2
fi

find . | egrep "\.(c|h)$" | zip -@ $ASSGN.zip 
echo 
unzip -l $ASSGN.zip

echo
read -p "Handin? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    handin kmammen-grader $ASSGN-Section9 $ASSGN.zip
fi
echo "Done."