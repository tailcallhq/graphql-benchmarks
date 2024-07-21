#!/bin/bash

rm results.md

for bench in 1 2 3; do
    if ls bench${bench}*.txt &> /dev/null; then
        echo "Processing files for bench${bench}:"
        bash analyze.sh bench${bench}*.txt
        echo "Files processed: $(ls bench${bench}*.txt)"
    else
        echo "No matching files found for bench${bench}*.txt"
    fi
done