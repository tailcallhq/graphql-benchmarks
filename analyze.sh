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
  ["async_graphql"]="async-graphql"
  ["hasura"]="Hasura"
  ["graphql_jit"]="GraphQL JIT"
)

servers=("apollo" "caliban" "netflixdgs" "gqlgen" "tailcall" "async_graphql" "hasura" "graphql_jit")
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

echo "Server Value" >"$reqSecData"
for server in "${servers[@]}"; do
  echo "$server ${avgReqSecs[$server]}" >>"$reqSecData"
done

echo "Server Value" >"$latencyData"
for server in "${servers[@]}"; do
  echo "$server ${avgLatencies[$server]}" >>"$latencyData"
done

whichBench=1
if [[ $1 == bench2* ]]; then
    whichBench=2
elif [[ $1 == bench3* ]]; then
    whichBench=3
fi

reqSecHistogramFile="req_sec_histogram${whichBench}.png"
latencyHistogramFile="latency_histogram${whichBench}.png"

# Plotting using gnuplot
gnuplot <<-EOF
    set term pngcairo size 1280,720 enhanced font "Courier,12"
    set output "$reqSecHistogramFile"
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

    set output "$latencyHistogramFile"
    set title "Latency (in ms)"
    stats "$latencyData" using 2 nooutput
    set yrange [0:STATS_max*1.2]
    plot "$latencyData" using 2:xtic(1) title "Latency"
EOF

# Move PNGs to assets
mkdir -p assets
mv $reqSecHistogramFile assets/
mv $latencyHistogramFile assets/

# Declare an associative array for server RPS
declare -A serverRPS

# Populate the serverRPS array
for server in "${servers[@]}"; do
  serverRPS[$server]=${avgReqSecs[$server]}
done

# Get the servers sorted by RPS in descending order
IFS=$'\n' sortedServers=($(for server in "${!serverRPS[@]}"; do echo "$server ${serverRPS[$server]}"; done | sort -rn -k2 | cut -d' ' -f1))

echo "Sorted servers: ${sortedServers[@]}"
lastServer="${sortedServers[-1]}"
lastServerReqSecs=${avgReqSecs[$lastServer]}

# Start building the resultsTable
if [[ $whichBench == 1 ]]; then
    resultsTable="<!-- PERFORMANCE_RESULTS_START -->\n\n| Query | Server | Requests/sec | Latency (ms) | Relative |\n|-------:|--------:|--------------:|--------------:|---------:|\n| $whichBench | \`{ posts { id userId title user { id name email }}}\` |"
elif [[ $whichBench == 2 ]]; then
    resultsTable="| $whichBench | \`{ posts { title }}\` |"
elif [[ $whichBench == 3 ]]; then
    resultsTable="| $whichBench | \`{ greet }\` |"
fi

# Build the resultsTable with sorted servers and formatted numbers
for server in "${sortedServers[@]}"; do
    formattedReqSecs=$(printf "%.2f" ${avgReqSecs[$server]} | perl -pe 's/(?<=\d)(?=(\d{3})+(\.\d*)?$)/,/g')
    formattedLatencies=$(printf "%.2f" ${avgLatencies[$server]} | perl -pe 's/(?<=\d)(?=(\d{3})+(\.\d*)?$)/,/g')
    # Calculate the relative performance
    relativePerformance=$(echo "${avgReqSecs[$server]} $lastServerReqSecs" | awk '{printf "%.2f", $1 / $2}')

    resultsTable+="\n|| [${formattedServerNames[$server]}] | \`${formattedReqSecs}\` | \`${formattedLatencies}\` | \`${relativePerformance}x\` |"
done

if [[ $whichBench == 3 ]]; then
    resultsTable+="\n\n<!-- PERFORMANCE_RESULTS_END -->"
fi

echo "resultsTable: $resultsTable"

# Print the results table in a new file
resultsFile="results.md"
echo -e $resultsTable >> $resultsFile


if [[ $whichBench == 3 ]]; then
    finalResults=$(printf '%s\n' "$(cat $resultsFile)" | sed 's/$/\\n/'| tr -d '\n')
    # Remove the last newline character
    finalResults=${finalResults::-2}

    # Print the results as a table in the terminal
    echo -e $finalResults | sed "s/<!-- PERFORMANCE_RESULTS_START-->//;s/<!-- PERFORMANCE_RESULTS_END-->//"
    # Check if the markers are present
    if grep -q "PERFORMANCE_RESULTS_START" README.md; then
        # Replace the old results with the new results
        sed -i "/PERFORMANCE_RESULTS_START/,/PERFORMANCE_RESULTS_END/c\\$finalResults" README.md
    else
        # Append the results at the end of the README.md file
        echo -e "\n$finalResults" >> README.md
    fi
fi

# Move the generated images to the assets folder
mv $reqSecHistogramFile assets/
mv $latencyHistogramFile assets/

# Delete the result TXT files
for file in "${resultFiles[@]}"; do
  rm "$file"
done