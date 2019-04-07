#!/bin/bash
# Gets the assignment info 
# Usage:
#   ./getasgn.sh 
#   Run in the directory where you intend to copy the files.
#   Directory's name must be formatted ExerciseN or ProjectN

ASGN="//home/kmammen-grader/evaluations/S19/357/${PWD##*/}"
FEATURE_ASGN="$ASGN/tests/feature"
                                                                                                                                                                                                                                                                                                                                                        
# Copy makefile and requirements description
cp $ASGN/Makefile .
cp $ASGN/requirements . 

LOC="tests/desc"
mkdir -p $LOC
rm $LOC/*

# Copy value of core tests
echo -e "Value of core tests: \c" >> $LOC/core.txt
cat $ASGN/tests/core/value >> $LOC/core.txt 

# $1: path to valgrind test
# #2: name of text doc to copy to 
function copy_valgrind {
	# Copy valgrind info if it exists
	if [ -f $1/valgrind ]; then
		echo -e "Valgrind time limit: \c" >> $LOC/$2
		cat $1/valgrind >> $LOC/$2
	else # add a newline
		echo >> $LOC/$2
	fi
}

# Copy description and valgrind of each core test
for test in $ASGN/tests/core/test[[:digit:]]*; do
	cat $test/description | tr '\n' ' ' >> $LOC/core.txt
	copy_valgrind "$test" "core.txt"
done

# Copy description, value, and valgrind of each feature test
while read test; do
	cat $FEATURE_ASGN/$test/description | tr '\n' ' ' >> $LOC/feature.txt

	# Copy value
  	echo -e "Value: \c" >> $LOC/feature.txt
  	cat $FEATURE_ASGN/$test/value | tr '\n' ' ' >> $LOC/feature.txt

	copy_valgrind "$FEATURE_ASGN/$test" "feature.txt"
done <$FEATURE_ASGN/testList

# Copy CPU, memory tests if they exist 
function copy_cpu_mem_tests {
	if [ -f $ASGN/$1 ]; then
		for test in $ASGN/$1/test[[:digit:]]; do
			cat $test/description | tr '\n' ' ' >> $LOC/$1.txt
			echo -e "Value of $1 tests: \c" >> $LOC/$1.txt
			cat $ASGN/tests/$1/value >> $LOC/$1.txt
		done
	fi
}

copy_cpu_mem_tests "cpu"
copy_cpu_mem_tests "heap"