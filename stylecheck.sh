#!/bin/bash
# Stylechecks all .c files in the directory
# Usage: ./stylecheck.sh

# Suppresses error message if no c files in directory
shopt -s nullglob 
~kmammen-grader/bin/styleCheckC *.c
