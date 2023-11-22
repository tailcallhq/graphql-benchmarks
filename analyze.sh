#!/bin/bash

function extractMetric() {
    local file="$1"
    local metric="$2"
    grep "$metric" "$file" | awk '{print $2}' | sed 's/ms//'
}

function average() {
    echo "$@" | awk '{for(i=1;i<=NF;i++) s+=$i; print s/NF}'
}

declare -A formattedServerNames
formattedServerNames=(
    ["tailcall"]="Tailcall"
    ["gqlgen"]="Gqlgen"
    ["apollo"]="Apollo GraphQL"
    ["netflixdgs"]="Netflix DGS"
    ["caliban"]="Caliban"
)

servers=("apollo" "caliban" "netflixdgs" "gqlgen" "tailcall")
resultFiles=("$@")
declare -A avgReqSecs
declare -A avgLatencies

# Extract metrics and calculate averages
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
mv req_sec_histogram.png assets/
mv latency_histogram.png assets/

# Declare an associative array for server RPS
declare -A serverRPS

# Populate the serverRPS array
for server in "${servers[@]}"; do
    serverRPS[$server]=${avgReqSecs[$server]}
done

# Get the servers sorted by RPS in descending order
IFS=$'\n' sortedServers=($(for server in "${!serverRPS[@]}"; do echo "$server ${serverRPS[$server]}"; done | sort -rn -k2 | cut -d' ' -f1))


echo "Sorted servers: ${sortedServers[@]}"
# Start building the resultsTable
resultsTable="<!-- PERFORMANCE_RESULTS_START -->\n\n| Server | Requests/sec | Latency (ms) |\n|--------:|--------------:|--------------:|"

# Build the resultsTable with sorted servers and formatted numbers
for server in "${sortedServers[@]}"; do
    formattedReqSecs=$(printf "%.2f" ${avgReqSecs[$server]} | perl -pe 's/(?<=\d)(?=(\d{3})+(\.\d*)?$)/,/g')
    formattedLatencies=$(printf "%.2f" ${avgLatencies[$server]} | perl -pe 's/(?<=\d)(?=(\d{3})+(\.\d*)?$)/,/g')
    resultsTable+="\n| [${formattedServerNames[$server]}] | \`${formattedReqSecs}\` | \`${formattedLatencies}\` |"
done

resultsTable+="\n\n<!-- PERFORMANCE_RESULTS_END -->"

echo -e $resultsTable

# Check if the markers are present
if grep -q "PERFORMANCE_RESULTS_START" README.md; then
    # Replace the old results with the new results
    sed -i "/PERFORMANCE_RESULTS_START/,/PERFORMANCE_RESULTS_END/c\\$resultsTable" README.md
else
    # Append the results at the end of the README.md file
    echo -e "\n$resultsTable" >> README.md
fi

# Print the results table in a new file
echo -e $resultsTable > results.md

# Print the results as a table in the terminal
echo -e $resultsTable | sed "s/<!-- PERFORMANCE_RESULTS_START -->//;s/<!-- PERFORMANCE_RESULTS_END -->//"

# Move the generated images to the assets folder
mv req_sec_histogram.png assets/
mv latency_histogram.png assets/

# Delete the result TXT files
for file in "${resultFiles[@]}"; do
    rm "$file"
done
