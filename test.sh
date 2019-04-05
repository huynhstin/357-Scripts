#!/bin/bash
# Run tests for an assignment in 357
# Run ./test.sh inside a folder with the name of the assignment: ex /Exercise5/

ASGN=${PWD##*/}
TEST_DIRECTORY="//home/kmammen/357/$ASGN/"
HOME="/home/jhuynh42/357/${ASGN::-1}s/$ASGN"
fail=0
input=0

function run_tests {
    for test in $HOME/tests/*.in ; do
        echo -e "    Running $test..."
        if [ ! -f $test ]; then
            echo "-> No test.in's found. Running reference solution without them... "
            echo "-> Note that all test.in's should be located in /tests. "
            $2 > $HOME/tests/no_in.$1
            break
        else 
            name=${test::-3}
            if [[ input -eq 1 ]]; then # is an input file 
                $2 < $test &> $name.$1
            else # is command line args
                # remove old test output
                rm -f $name.$1
                while read arg; do
                    $2 $arg &>> $name.$1
                done <"$test"
            fi
        fi
    done
}

if [ -d $TEST_DIRECTORY ]; then 
    mkdir -p tests

    read -p "Are your test files input (1) or command line arguments (2)? " -n 1 -r
    echo
    let input=$REPLY

    echo "-> Running reference solution... "
    for file in $TEST_DIRECTORY/*; do 
        echo $file
        run_tests "expect" "$file"
    done

    echo -e "\n-> Running your solution... "
    echo "$HOME/a.out"
    make clean
    make

    run_tests "actual" "$HOME/a.out"

    echo -e "\n-> Diff'ing outputs... "
    for test in $HOME/tests/*.actual; do
        DIFF_OUT="$(diff $test ${test::-7}.expect)" 
        testname="${test##*/}"
        if [[ "${#DIFF_OUT}" -gt 0 ]]; then # diff outputted something
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
        echo -e "At least one test failed."
    fi
else
    echo "Reference solution does not exist. Exiting.... "
    exit 1
fi

