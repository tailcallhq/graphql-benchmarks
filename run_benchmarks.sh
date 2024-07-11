#!/bin/bash

# Function to kill server on a specific port
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

        bash "test_query${bench}.sh" "$graphqlEndpoint" || echo "Failed to run test_query${bench}.sh"

        # Warmup run
        bash "$benchmarkScript" "$graphqlEndpoint" "$bench" >/dev/null 2>&1 || echo "Failed warmup run $bench"
        sleep 1
        bash "$benchmarkScript" "$graphqlEndpoint" "$bench" >/dev/null 2>&1 || echo "Failed warmup run $bench"
        sleep 1
        bash "$benchmarkScript" "$graphqlEndpoint" "$bench" >/dev/null 2>&1 || echo "Failed warmup run $bench"
        sleep 1

        # Actual benchmark run
        echo "Running benchmark $bench for $serviceScript"
        bash "$benchmarkScript" "$graphqlEndpoint" "$bench" >"bench${bench}_${resultFile}" 2>&1 || echo "Failed benchmark run $bench"
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
if [ -z "$serviceScript" ]; then
    echo "Error: No service script provided"
    exit 1
fi

runBenchmark "$serviceScript"