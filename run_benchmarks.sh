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
bench1Results=()
bench2Results=()
bench3Results=()
killServerOnPort 3000
sh nginx/run.sh

function runBenchmark() {
    killServerOnPort 8000
    sleep 5
    local serviceScript="$1"
    local benchmarks=(1 2 3)

    bash "$serviceScript" &   # Run in daemon mode
    sleep 15   # Give some time for the service to start up

    for bench in "${benchmarks[@]}"; do
        local benchmarkScript="wrk/bench.sh"
        
        # Replace / with _
        local sanitizedServiceScriptName=$(echo "$serviceScript" | tr '/' '_')
        
        local resultFiles=("result1_${sanitizedServiceScriptName}.txt" "result2_${sanitizedServiceScriptName}.txt" "result3_${sanitizedServiceScriptName}.txt")

        bash "test_query${bench}.sh"

        # Warmup run
        bash "$benchmarkScript" "$bench" > /dev/null
        sleep 1   # Give some time for apps to finish in-flight requests from warmup
        bash "$benchmarkScript" "$bench" > /dev/null
        sleep 1
        bash "$benchmarkScript" "$bench" > /dev/null
        sleep 1


        # 3 benchmark runs
        for resultFile in "${resultFiles[@]}"; do
            echo "Running benchmark $bench for $serviceScript"
            bash "$benchmarkScript" "$bench" > "bench${bench}_${resultFile}"
            if [ "$bench" == "1" ]; then
                bench1Results+=("bench1_${resultFile}")
            elif [ "$bench" == "2" ]; then
                bench2Results+=("bench2_${resultFile}")
            elif [ "$bench" == "3" ]; then
                bench3Results+=("bench3_${resultFile}")
            fi
        done
    done
}

rm "results.md"

for service in "apollo_server" "caliban" "netflix_dgs" "gqlgen" "tailcall" "async_graphql"; do
    runBenchmark "graphql/${service}/run.sh"
    if [ "$service" == "apollo_server" ]; then
        cd graphql/apollo_server/
        npm stop
        cd ../../
    fi
done

bash analyze.sh "${bench1Results[@]}"
bash analyze.sh "${bench2Results[@]}"
bash analyze.sh "${bench3Results[@]}"
