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
    local port="$2"
    
    # Replace / with _
    local sanitizedServiceScriptName=$(echo "$serviceScript" | tr '/' '_')
    
    local resultFiles=("result1_${sanitizedServiceScriptName}.json" "result2_${sanitizedServiceScriptName}.json" "result3_${sanitizedServiceScriptName}.json")

    bash "$serviceScript" &   # Run in daemon mode
    sleep 15   # Give some time for the service to start up

    # Warmup run
    bash "./generate_load.sh" "$port" > /dev/null

    # 3 benchmark runs
    for resultFile in "${resultFiles[@]}"; do
        bash "./generate_load.sh" "$port" > "$resultFile"
        allResults+=("$resultFile")
    done
}

runBenchmark "graphql/apollo_server/run.sh" 8080
cd graphql/apollo_server/
npm stop
cd ../../

# killServerOnPort 8082
# runBenchmark "graphql/netflix_dgs/run.sh" 8082
# killServerOnPort 8082

# killServerOnPort 8081
# runBenchmark "graphql/gqlgen/run.sh" 8081
# killServerOnPort 8081

killServerOnPort 8083
runBenchmark "graphql/tailcall/run.sh" 8083
killServerOnPort 8083

# Now, analyze all results together
node analyze.js "${allResults[@]}"
