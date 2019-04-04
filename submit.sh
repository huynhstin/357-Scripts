#!/bin/bash
# Submits assignment for 357. 
# Run ./submit.sh inside a folder with the name of the assignment: ex /Exercise5/
ASGN=${PWD##*/}

STYLECHECK_OUT="$(/home/jhuynh42/357/Scripts/stylecheck.sh)"
echo -e "$STYLECHECK_OUT"
echo 

# Run stylecheck and exit if failed
if echo "$STYLECHECK_OUT" | grep 'FAILED'; then
    echo "Aborting."
    exit 1
fi

# Run tests and exit if failed
TEST_OUT="$(/home/jhuynh42/357/Scripts/test.sh)"
echo -e "$TEST_OUT\n"
if echo "$TEST_OUT" | grep 'test failed'; then
    echo "Aborting."
    exit 1
fi

# Zip all .c and .h files in a directory into a file named DIRECTORY.zip
find . | egrep "\.(c|h)$" | zip -@ $ASGN.zip 
echo 

# Echo contents of zip file 
unzip -l $ASGN.zip
echo 

# Prompt for handin
read -p "Handin? " -n 1 -r
echo 
if [[ $REPLY =~ ^[Yy]$ ]]
then
    handin kmammen-grader $ASGN-Section9 $ASGN.zip
fi
echo "Done."
