#!/bin/bash

function extractData() {
    local file="$1"
    local requestsPerSec=$(awk '/Requests\/sec:/ {print $2}' "$file")
    local transferPerSec=$(awk '/Transfer\/sec:/ {print $2}' "$file")
    echo "$requestsPerSec requests/sec, $transferPerSec transfer/sec"
}

files=("$@")

echo "Comparison Report"
echo "-----------------"

for file in "${files[@]}"; do
    result=$(extractData "$file")
    echo "Result from $file: $result"
done

# Add more comparison logic if needed
