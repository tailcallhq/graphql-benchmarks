#!/bin/bash
docker compose up -d
sleep 10
allResults=()

function runBenchmark() {
    local port="$2"
    local serviceName="$1"
    local benchmarkScript="wrk/bench.sh"

    local resultFiles=("result1_${serviceName}.txt" "result2_${serviceName}.txt" "result3_${serviceName}.txt")

    bash "test_query.sh" $port

    # Warmup run
    bash "$benchmarkScript" $port > /dev/null
    sleep 1   # Give some time for apps to finish in-flight requests from warmup
    bash "$benchmarkScript" $port > /dev/null
    sleep 1
    bash "$benchmarkScript" $port > /dev/null
    sleep 1


    # 3 benchmark runs
    for resultFile in "${resultFiles[@]}"; do
        bash "$benchmarkScript" $port > "$resultFile"
        allResults+=("$resultFile")
    done
}

runBenchmark "apollo_server" 8001
runBenchmark "async_graphql" 8002
runBenchmark "caliban" 8003
runBenchmark "gqlgen" 8004
runBenchmark "netflix_dgs" 8005
runBenchmark "tailcall" 8006

docker compose down

# Now, analyze all results together
bash analyze.sh "${allResults[@]}"