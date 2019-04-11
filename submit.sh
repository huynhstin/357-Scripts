#!/bin/bash
# Submits assignment for 357. 
# Run ./submit.sh inside a folder with the name of the assignment: ex /Exercise5/
ASGN=${PWD##*/}
mkdir -p tests

STYLECHECK_OUT="$(/home/jhuynh42/357/Scripts/stylecheck.sh)"
echo -e "$STYLECHECK_OUT"
echo 

# Run stylecheck and exit if failed
if [[ $STYLECHECK_OUT == *"FAILED style check"* ]]; then 
    echo "Aborting."
    exit 1
fi

# Get makefile and requirements if not already there
/home/jhuynh42/357/Scripts/getasgn.sh

# Ensure requirements fulfilled
echo "Make sure that your code follows the requirements:"
cat requirements
echo

echo "Make sure that your code is within the complexity metrics: "
/home/jhuynh42/357/Scripts/complexstats.sh
echo

# Run tests and exit if failed
TEST_OUT="$(/home/jhuynh42/357/Scripts/test.sh)"
echo -e "$TEST_OUT\n"
if [[ $TEST_OUT == *"test failed"* ]]; then 
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
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if [[ $ASGN == "Exercise"* ]]; then 
        handin kmammen-grader $ASGN-Section9 $ASGN.zip 
        handin kmammen-grader $ASGN-Section9
    else
        handin kmammen-grader $ASGN $ASGN.zip 
        handin kmammen-grader $ASGN
    fi
fi
echo "Done."
