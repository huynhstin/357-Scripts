#!/bin/bash
# Run tests for an assignment in 357
# Run ./test.sh inside a folder with the name of the assignment: ex /Exercise5/

ASGN=${PWD##*/}
TEST_DIRECTORY="//home/kmammen/357/$ASGN/"
HOME="/home/jhuynh42/357/${ASGN::-1}s"
fail=0
input=0

if [ -d $TEST_DIRECTORY ]; then 
    mkdir -p tests
    echo "-> Running reference solution... "
    for file in $TEST_DIRECTORY/*; do 
        echo $file

        # Ask user if test.in file is input or command line argument
        read -p "Are your test files input (1) or command line arguments (2)? " -n 1 -r
        echo
        let input=$REPLY

        # if test.in's exist, run them and put results in /tests; else run without test.in
        for test in $HOME/$ASGN/tests/*.in ; do
            echo $test
            if [ ! -f $test ]; then
                echo "-> No test.in's found. Running reference solution without them... "
                echo "-> Note that all test.in's should be located in /tests. "
                $file > $HOME/$ASGN/tests/test01.expect
                break
            else 
                name=${test::-3}
                if [[ input -eq 1 ]]; then # is an input file 
                    $file < $test > $name.expect
                else # is command line args
                    # remove old test output
                    rm -f $name.expect
                    while read arg; do
                        $file $arg >> $name.expect
                    done <"$test"
                fi
            fi
        done
    done

    echo -e "\n-> Running your solution... "
    echo "$HOME/$ASGN/a.out"
    make clean
    make
    for test in $HOME/$ASGN/tests/*.in ; do
        if [ ! -f $test ]; then
            echo "-> No test.in's found. Running your solution without them... "
            echo "-> Note that all test.in's should be located in /tests. "
            ./a.out > $HOME/$ASGN/tests/test01.actual
            break
        else 
            name=${test::-3}
            if [[ input -eq 1 ]]; then # is an input file 
                ./a.out < $test > $name.actual
            else # is command line args
                # remove old test output
                rm -f $name.actual
                while read arg; do
                    ./a.out $arg >> $name.actual
                done <"$test"
            fi
        fi
    done

    echo -e "\n-> Diff'ing outputs... "
    for test in $HOME/$ASGN/tests/*.actual; do
        DIFF_OUT="$(diff $test ${test::-7}.expect)" 
        testname="${test##*/}"
        if [[ "${#DIFF_OUT}" -gt 0 ]]; then
            echo "${testname::-7} failed!"
            diff -q $test ${test::-7}.expect
            echo -e "$DIFF_OUT\n"
            let fail=1
        else
            echo "${testname::-7} passed!"
        fi
    done

    if [[ fail -eq 0 ]]; then
        echo -e "All tests passed!"
    else 
        echo -e "At least one test failed. Fix before submitting!"
    fi
else
    echo "Reference solution does not exist. Exiting.... "
    exit 1
fi

