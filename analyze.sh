#!/bin/bash

function extractMetric() {
    local file="$1"
    local metric="$2"
    grep "$metric" "$file" | awk '{print $2}' | sed 's/ms//'
}

function average() {
    echo "$@" | awk '{for(i=1;i<=NF;i++) s+=$i; print s/NF}'
}

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

# Generating data files for gnuplot
reqSecData="/tmp/reqSec.dat"
latencyData="/tmp/latency.dat"

echo "Server Value" > "$reqSecData"
for server in "${servers[@]}"; do
    echo "$server ${avgReqSecs[$server]}" >> "$reqSecData"
done

echo "Server Value" > "$latencyData"
for server in "${servers[@]}"; do
    echo "$server ${avgLatencies[$server]}" >> "$latencyData"
done

# Plotting using gnuplot
gnuplot <<- EOF
    set term png
    set output "reqSecHistogram.png"
    set style data histograms
    set style histogram cluster gap 1
    set style fill solid border -1
    set xtics rotate by -45
    set boxwidth 0.9
    set title "Requests/Sec"
    plot "$reqSecData" using 2:xtic(1) title "Req/Sec"

    set output "latencyHistogram.png"
    set title "Latency (in ms)"
    plot "$latencyData" using 2:xtic(1) title "Latency"
EOF

echo "Generated reqSecHistogram.png and latencyHistogram.png"

# Add, commit, and push PNGs
git add reqSecHistogram.png latencyHistogram.png
git commit -m "Added performance histograms"
git push

# Delete the TXT files
for file in "${resultFiles[@]}"; do
    rm "$file"
done