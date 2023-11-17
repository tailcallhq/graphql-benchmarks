#!/bin/bash

# Start services and run benchmarks
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
allResults=()
killServerOnPort 3000
sh nginx/run.sh

function runBenchmark() {
    local serviceScript="$1"
    local benchmarkScript="$2"
    
    # Replace / with _
    local sanitizedServiceScriptName=$(echo "$serviceScript" | tr '/' '_')
    
    local resultFiles=("result1_${sanitizedServiceScriptName}.txt" "result2_${sanitizedServiceScriptName}.txt" "result3_${sanitizedServiceScriptName}.txt")

    bash "$serviceScript" &   # Run in daemon mode
    sleep 15   # Give some time for the service to start up

    # Warmup run
    bash "$benchmarkScript" > /dev/null

    # 3 benchmark runs
    for resultFile in "${resultFiles[@]}"; do
        bash "$benchmarkScript" > "$resultFile"
        allResults+=("$resultFile")
    done
}

runBenchmark "graphql/apollo_server/run.sh" "wrk/apollo_bench.sh"
cd graphql/apollo_server/
npm stop
cd ../../

killServerOnPort 8000

runBenchmark "graphql/netflix_dgs/run.sh" "wrk/dgs_bench.sh"

killServerOnPort 8000

runBenchmark "graphql/gqlgen/run.sh" "wrk/gqlgen_bench.sh"

killServerOnPort 8000

runBenchmark "graphql/tailcall/run.sh" "wrk/tc_bench.sh"

killServerOnPort 8000

# Now, analyze all results together
bash analyze.sh "${allResults[@]}"