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

# Generate the new performance results for README.md
new_results=$(cat <<- EOM
<!-- PERFORMANCE_RESULTS_START -->
| Server | Requests/sec | Latency (ms) |
|--------|--------------|--------------|
EOM
)

for server in "${servers[@]}"; do
    new_results+=$'\n'"| $server | ${avgReqSecs[$server]} | ${avgLatencies[$server]} |"
done

new_results+=$'\n'"<!-- PERFORMANCE_RESULTS_END -->"$'\n'

# Check for marker in README.md
if grep -q "<!-- PERFORMANCE_RESULTS_START -->" README.md; then
    # If marker exists, replace the old results with the new ones
    awk -v r="$new_results" '
        /<!-- PERFORMANCE_RESULTS_START -->/, /<!-- PERFORMANCE_RESULTS_END -->/ {
            if (/<!-- PERFORMANCE_RESULTS_START -->/) {
                print r;
            }
        }
        ! /<!-- PERFORMANCE_RESULTS_START -->/, ! /<!-- PERFORMANCE_RESULTS_END -->/ {
            print;
        }
    ' README.md > README.md.tmp && mv README.md.tmp README.md
else
    # If marker doesn't exist, append the marker and performance results to the end of README.md
    echo "$new_results" >> README.md
fi

# Print results in terminal as table
echo -e "\nPerformance Results:"
echo "----------------------------------"
printf "| %-10s | %-12s | %-12s |\n" "Server" "Requests/sec" "Latency (ms)"
echo "----------------------------------"
for server in "${servers[@]}"; do
    printf "| %-10s | %-12s | %-12s |\n" "$server" "${avgReqSecs[$server]}" "${avgLatencies[$server]}"
done
echo "----------------------------------"

# Add, commit, and push PNGs and README.md
git add assets/req_sec_histogram.png assets/latency_histogram.png README.md
git commit -m "Added performance histograms and updated README"
git push

# Delete the result TXT files
for file in "${resultFiles[@]}"; do
    rm "$file"
done
