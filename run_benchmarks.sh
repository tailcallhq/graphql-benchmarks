#!/bin/bash

# kill a server running on a specific port
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

# kill any existing services on specific ports and start nginx
killServerOnPort 3000
sh nginx/run.sh

# run the benchmarks for a specific GraphQL service
function runBenchmark() {
    local serviceScript="$1"
    killServerOnPort 8000
    sleep 2 # Reduced from 5 to 2

    if [[ "$serviceScript" == *"hasura"* ]]; then
        bash "$serviceScript" # Run synchronously without background process
    else
        bash "$serviceScript" & # Run in daemon mode
    fi

    sleep 10 # Reduced from 15 to 10

    local graphqlEndpoint="http://localhost:8000/graphql"
    if [[ "$serviceScript" == *"hasura"* ]]; then
        graphqlEndpoint=http://$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' graphql-engine):8080/v1/graphql
    fi

    local benchmarks=(1 2 3)
    for bench in "${benchmarks[@]}"; do
        local benchmarkScript="wrk/bench.sh"
        local sanitizedServiceScriptName=$(echo "$serviceScript" | tr '/' '_')
        local resultFile="result${bench}_${sanitizedServiceScriptName}.txt"

        bash "test_query${bench}.sh" "$graphqlEndpoint"

        # Parallel warmup runs
        {
            bash "$benchmarkScript" "$graphqlEndpoint" "$bench" >/dev/null &
            bash "$benchmarkScript" "$graphqlEndpoint" "$bench" >/dev/null &
            bash "$benchmarkScript" "$graphqlEndpoint" "$bench" >/dev/null &
            wait
        }

        # 3 benchmark runs
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
    fi
}

rm -f "results.md"

# Export functions for parallel execution
export -f runBenchmark killServerOnPort
services=("graphql/apollo_server/run.sh" "graphql/caliban/run.sh" "graphql/netflix_dgs/run.sh" "graphql/gqlgen/run.sh" "graphql/tailcall/run.sh" "graphql/async_graphql/run.sh" "graphql/hasura/run.sh" "graphql/graphql_jit/run.sh")

# Run all benchmarks in parallel
printf "%s\n" "${services[@]}" | xargs -n 1 -P 0 -I {} bash -c 'runBenchmark "$@"' _ {}

# Concurrent result analysis
{
    bash analyze.sh "${bench1Results[@]}" &
    bash analyze.sh "${bench2Results[@]}" &
    bash analyze.sh "${bench3Results[@]}" &
    wait
}
