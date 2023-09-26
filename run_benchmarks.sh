#!/bin/bash

# Start services and run benchmarks
sh nginx/run.sh

function runBenchmark() {
    local serviceScript="$1"
    local benchmarkScript="$2"
    local tempFile="temp_bench.txt"
    local resultFiles=("result1.txt" "result2.txt" "result3.txt")

    sh "$serviceScript"

    # Warmup run
    sh "$benchmarkScript" > /dev/null

    # 3 benchmark runs
    for resultFile in "${resultFiles[@]}"; do
        sh "$benchmarkScript" > "$resultFile"
    done

    analyzeResults "${resultFiles[@]}"

    rm -f "${resultFiles[@]}"
}

function analyzeResults() {
    local resultFiles=("$@")
    # Analysis and comparison logic goes here, or you can call another script
    # that takes these files as input and outputs a report.
    sh analyze.sh "${resultFiles[@]}"
}

runBenchmark "graphql/apollo-server/run.sh" "wrk/apollo-bench.sh"
sh graphql/apollo-server/run.sh
npm stop

runBenchmark "graphql/netflixdgs/run.sh" "wrk/dgs-bench.sh"
runBenchmark "graphql/gqlgen/run.sh" "wrk/gqlgen-bench.sh"
runBenchmark "graphql/tailcall/run.sh" "wrk/tc-bench.sh"
