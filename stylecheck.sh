#!/bin/bash
# Stylechecks all .c files in the directory
# Usage: ./stylecheck.sh

shopt -s nullglob 
for file in *.c; do
    ~kmammen-grader/bin/styleCheckC $file
done
