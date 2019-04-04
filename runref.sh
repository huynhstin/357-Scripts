#!/bin/bash
# Save the expected output to a file in /tests
# Run ./test.sh inside a folder with the name of the assignment: ex /Exercise5/

ASGN=${PWD##*/}
TEST_DIRECTORY="//home/kmammen/357/$ASGN/"
HOME="/home/jhuynh42/357/${ASGN::-1}s"
fail=0

if [ -d $TEST_DIRECTORY ]; then
    mkdir -p tests
    echo "-> Running reference solution... "
    for file in $TEST_DIRECTORY/*; do
        echo $file

        # Run each test.in file if they exist
        for test in $HOME/$ASGN/tests/*.in ; do
            echo $test
            if [ ! -f $test ]; then
                echo "-> No test.in's found. Running reference solution without them... "
                echo "-> Note that all test.in's should be located in /tests/. "
                $file > $HOME/$ASGN/tests/test01.expect
                break
            else
                $file < $test > ${test::-3}.expect
            fi
        done
    done

