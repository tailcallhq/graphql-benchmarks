#!/bin/bash

function extractMetric() {
    local file="$1"
    local metric="$2"
    grep "$metric" "$file" | awk '{print $2}' | sed 's/ms//'
}

function average() {
    echo "$@" | awk '{for(i=1;i<=NF;i++) s+=$i; print s/NF}'
}

# Assuming you run benchmarks for 4 servers
servers=("apollo" "netflixdgs" "gqlgen" "tailcall")
resultFiles=("$@")
declare -A avgReqSecs
declare -A avgLatencies

for idx in "${!servers[@]}"; do
    startIdx=$((idx * 3))
    reqSecVals=()
    latencyVals=()
    for j in 0 1 2; do
        fileIdx=$((startIdx + j))
        reqSecVals+=($(extractMetric "${resultFiles[$fileIdx]}" "Requests/sec"))
        latencyVals+=($(extractMetric "${resultFiles[$fileIdx]}" "Latency"))
    done
    avgReqSecs[${servers[$idx]}]=$(average "${reqSecVals[@]}")
    avgLatencies[${servers[$idx]}]=$(average "${latencyVals[@]}")
done

echo "Comparative Analysis:"

# Generating histograms (using '#' for visualization)
echo -e "\nReq/Sec Histogram:"
for server in "${servers[@]}"; do
    echo "$server ${avgReqSecs[$server]} $(printf '#%.0s' $(seq 1 ${avgReqSecs[$server]}))"
done

echo -e "\nLatency Histogram (in ms):"
for server in "${servers[@]}"; do
    echo "$server ${avgLatencies[$server]} $(printf '#%.0s' $(seq 1 ${avgLatencies[$server]}))"
done
