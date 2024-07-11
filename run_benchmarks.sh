#!/bin/bash

# Start services and run benchmarks
function killServerOnPort() {
    local port="$1"
    local pid=$(lsof -t -i:"$port")
	@@ -17,65 +17,72 @@ bench1Results=()
bench2Results=()
bench3Results=()

# Kill any existing services on specific ports and start nginx
killServerOnPort 3000
sh nginx/run.sh

# run the benchmarks for a specific GraphQL service
function runBenchmark() {
    killServerOnPort 8000
    sleep 2
    local serviceScript="$1"
    local benchmarks=(1 2 3)

    if [[ "$serviceScript" == *"hasura"* ]]; then
        bash "$serviceScript" # Run synchronously without background process
    else
        bash "$serviceScript" & # Run in daemon mode
    fi

    sleep 10

    local graphqlEndpoint="http://localhost:8000/graphql"
    if [[ "$serviceScript" == *"hasura"* ]]; then
        graphqlEndpoint=http://$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' graphql-engine):8080/v1/graphql
    fi

    for bench in "${benchmarks[@]}"; do
        local benchmarkScript="wrk/bench.sh"

        # Replace / with _
        local sanitizedServiceScriptName=$(echo "$serviceScript" | tr '/' '_')

        local resultFiles=("result1_${sanitizedServiceScriptName}.txt" "result2_${sanitizedServiceScriptName}.txt" "result3_${sanitizedServiceScriptName}.txt")

        bash "test_query${bench}.sh" "$graphqlEndpoint"

        # Warmup run
        bash "$benchmarkScript" "$graphqlEndpoint" "$bench" >/dev/null
        sleep 1 # Give some time for apps to finish in-flight requests from warmup
        bash "$benchmarkScript" "$graphqlEndpoint" "$bench" >/dev/null
        sleep 1
        bash "$benchmarkScript" "$graphqlEndpoint" "$bench" >/dev/null
        sleep 1

        # 3 benchmark runs
        for resultFile in "${resultFiles[@]}"; do
            echo "Running benchmark $bench for $serviceScript"
            bash "$benchmarkScript" "$graphqlEndpoint" "$bench" >"bench${bench}_${resultFile}"
            if [ "$bench" == "1" ]; then
                bench1Results+=("bench1_${resultFile}")
            elif [ "$bench" == "2" ]; then
                bench2Results+=("bench2_${resultFile}")
            elif [ "$bench" == "3" ]; then
                bench3Results+=("bench3_${resultFile}")
            fi
        done

        # Handle service-specific shutdown if necessary
        if [ "$serviceScript" == "graphql/apollo_server/run.sh" ]; then
            cd graphql/apollo_server/
            npm stop
            cd ../../
        elif [ "$serviceScript" == "graphql/hasura/run.sh" ]; then
            bash "graphql/hasura/kill.sh"
        else
            kill "$servicePid"
        fi
    done
}

rm -f "results.md"
	@@ -85,12 +92,18 @@ export -f runBenchmark killServerOnPort
services=("graphql/apollo_server/run.sh" "graphql/caliban/run.sh" "graphql/netflix_dgs/run.sh" "graphql/gqlgen/run.sh" "graphql/tailcall/run.sh" "graphql/async_graphql/run.sh" "graphql/hasura/run.sh" "graphql/graphql_jit/run.sh")

# Run all benchmarks in parallel
echo "Starting all benchmarks in parallel"
printf "%s\n" "${services[@]}" | xargs -n 1 -P 0 -I {} bash -c 'runBenchmark "$@"' _ {}

echo "All benchmarks completed"

# Concurrent result analysis
echo "Starting result analysis"
{
    bash analyze.sh "${bench1Results[@]}" &
    bash analyze.sh "${bench2Results[@]}" &
    bash analyze.sh "${bench3Results[@]}" &
    wait
}

echo "Result analysis completed"
