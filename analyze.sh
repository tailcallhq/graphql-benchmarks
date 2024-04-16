#!/bin/bash

# Function to extract metrics from result files
function extractMetric() {
    local file="$1"
    local metric="$2"
    grep "$metric" "$file" | awk '{print $2}' | sed 's/ms//' || echo "Error extracting metric from $file"
}

# Function to calculate the average from provided numbers
function average() {
    echo "$@" | awk '{for(i=1;i<=NF;i++) s+=$i; print s/NF}'
}

# Associative array for formatted server names
declare -A formattedServerNames=(
    ["tailcall"]="Tailcall"
    ["gqlgen"]="Gqlgen"
    ["apollo"]="Apollo GraphQL"
    ["netflixdgs"]="Netflix DGS"
    ["caliban"]="Caliban"
    ["async_graphql"]="async-graphql"
)

servers=("apollo" "caliban" "netflixdgs" "gqlgen" "tailcall" "async_graphql")
resultFiles=("$@")
declare -A avgReqSecs
declare -A avgLatencies

# Main loop to extract metrics and calculate averages
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
echo "Server Value" > "$latencyData"

for server in "${servers[@]}"; do
    echo "$server ${avgReqSecs[$server]}" >> "$reqSecData"
    echo "$server ${avgLatencies[$server]}" >> "$latencyData"
done

# Plotting using gnuplot
gnuplot <<- EOF
    set term pngcairo size 1280,720 enhanced font "Courier,12"
    set output "req_sec_histogram.png"
    set style data histograms
    set style histogram cluster gap 1
    set style fill solid border -1
    set xtics rotate by -45
    set boxwidth 0.9
    set title "Requests/Sec"
    stats "$reqSecData" using 2 nooutput
    set yrange [0:STATS_max*1.2]
    set key outside right top
    plot "$reqSecData" using 2:xtic(1) title "Req/Sec"

    set output "latency_histogram.png"
    set title "Latency (in ms)"
    stats "$latencyData" using 2 nooutput
    set yrange [0:STATS_max*1.2]
    plot "$latencyData" using 2:xtic(1) title "Latency"
EOF

# Move PNGs to assets
mkdir -p assets
mv *.png assets/
