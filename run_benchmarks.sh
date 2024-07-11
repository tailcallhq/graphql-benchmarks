#!/bin/bash

# Function to run benchmark for a single service
function runBenchmark() {
    local serviceScript="$1"
    local benchmarks=(1 2 3)

    killServerOnPort 8000
    sleep 5

    if [[ "$serviceScript" == *"hasura"* ]]; then
        bash "$serviceScript" # Run synchronously without background process
    else
        bash "$serviceScript" & # Run in daemon mode
    fi

    sleep 15 # Give some time for the service to start up

    local graphqlEndpoint="http://localhost:8000/graphql"
    if [[ "$serviceScript" == *"hasura"* ]]; then
        graphqlEndpoint=http://$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' graphql-engine):8080/v1/graphql
    fi

    local sanitizedServiceScriptName=$(echo "$serviceScript" | tr '/' '_')

    for bench in "${benchmarks[@]}"; do
        local benchmarkScript="wrk/bench.sh"
        local resultFile="result${bench}_${sanitizedServiceScriptName}.txt"

        bash "test_query${bench}.sh" "$graphqlEndpoint"

        # Warmup run
        bash "$benchmarkScript" "$graphqlEndpoint" "$bench" >/dev/null
        sleep 1
        bash "$benchmarkScript" "$graphqlEndpoint" "$bench" >/dev/null
        sleep 1
        bash "$benchmarkScript" "$graphqlEndpoint" "$bench" >/dev/null
        sleep 1

        # Actual benchmark run
        echo "Running benchmark $bench for $serviceScript"
        bash "$benchmarkScript" "$graphqlEndpoint" "$bench" >"bench${bench}_${resultFile}"
    done

    # Cleanup
    if [ "$serviceScript" == "graphql/apollo_server/run.sh" ]; then
        cd graphql/apollo_server/
        npm stop
        cd ../../
    elif [ "$serviceScript" == "graphql/hasura/run.sh" ]; then
        bash "graphql/hasura/kill.sh"
    else
        killServerOnPort 8000
    fi
}

# Main execution
serviceScript="$1"
runBenchmark "$serviceScript"