#!/bin/bash
OUT_NAME="tests/complexity.out"

complexity -t0 -s1 *.c > $OUT_NAME
cat $OUT_NAME
echo

total=0
max=0
secondmax=-1
n=0

while read -r line; do
    set -- $line
    if [[ $1 =~ ^[0-9]+$ ]]; then # only get digits   
        if [ $1 -gt $max ]; then 
            secondmax=$max
            max=$1
        elif [ $1 > secondmax && [ !$1 -eq max ] ]; then
            secondmax=$1
        fi
        total=$((total+$1))
        n=$((n+1))
    fi
done < $OUT_NAME
if [[ secondmax -eq -1 ]]; then
    secondmax=$max
fi

# Calculate average to 1 decimal place
avg="$(bc <<<"scale=1; $total / $n")"

# Calculate ratio
tq="$(bc <<<"scale=5; ($n / 4)-1")"
ratio_sm="$(bc <<<"scale=5; $tq * $secondmax")"
ratio="$(bc <<<"scale=3; ($max + $ratio_sm) / $total")"

echo "Total complexity: $total"
echo "Max complexity: $max"
echo "Average complexity: $avg"
echo "Ratio: $ratio"