#!/bin/bash

# Start services and run benchmarks
# sh nginx/run.sh

function runBenchmark() {
    local serviceScript="$1"
    local benchmarkScript="$2"
    local tempFile="temp_bench.txt"
    local resultFiles=("result1.txt" "result2.txt" "result3.txt")

    bash "$serviceScript"

    # Warmup run
    bash "$benchmarkScript" > /dev/null

    # 3 benchmark runs
    for resultFile in "${resultFiles[@]}"; do
        bash "$benchmarkScript" > "$resultFile"
    done

    analyzeResults "${resultFiles[@]}"

    rm -f "${resultFiles[@]}"
}

function analyzeResults() {
    local resultFiles=("$@")
    # Analysis and comparison logic goes here, or you can call another script
    # that takes these files as input and outputs a report.
    bash analyze.sh "${resultFiles[@]}"
}

function killServerOnPort() {
    local port="$1"
    local pid=$(lsof -t -i:"$port")

    if [ -n "$pid" ]; then
        kill "$pid"
        echo "Killed process running on port $port"
    else
        echo "No process found running on port $port"
    fi
}

runBenchmark "graphql/apollo-server/run.sh" "wrk/apollo-bench.sh"
cd graphql/apollo-server/
npm stop
cd ../../

runBenchmark "graphql/netflixdgs/run.sh" "wrk/dgs-bench.sh"
killServerOnPort 8081

runBenchmark "graphql/gqlgen/run.sh" "wrk/gqlgen-bench.sh"
killServerOnPort 8082

runBenchmark "graphql/tailcall/run.sh" "wrk/tc-bench.sh"
killServerOnPort 8083
