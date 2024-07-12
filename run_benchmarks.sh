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

# Function to wait for service to be ready
function waitForService() {
    local endpoint="$1"
    local max_attempts=30
    local attempt=1
    
    while ! curl -s "$endpoint" > /dev/null; do
        if [ $attempt -ge $max_attempts ]; then
            echo "Service did not become available in time"
            exit 1
        fi
        echo "Waiting for service to be ready... (Attempt $attempt/$max_attempts)"
        sleep 1
        ((attempt++))
    done
    echo "Service is ready!"
}

# Function to run a single benchmark
function runSingleBenchmark() {
    local serviceScript="$1"
    local bench="$2"
    local graphqlEndpoint="$3"
    local sanitizedServiceScriptName="$4"
    local benchmarkScript="wrk/bench.sh"
    local resultFile="bench${bench}_result${bench}_${sanitizedServiceScriptName}.txt"

    echo "Running test query $bench for $serviceScript"
    bash "test_query${bench}.sh" "$graphqlEndpoint"
    
    echo "Running benchmark $bench for $serviceScript"
    bash "$benchmarkScript" "$graphqlEndpoint" "$bench" > "$resultFile"
}

# Function to run benchmarks
function runBenchmarks() {
    local serviceScript="$1"
    local graphqlEndpoint="$2"
    local sanitizedServiceScriptName="$3"

    # Run benchmarks in parallel using GNU Parallel
    parallel --jobs 3 runSingleBenchmark "$serviceScript" {1} "$graphqlEndpoint" "$sanitizedServiceScriptName" ::: 1 2 3
}

# Function to run benchmark for a specific server
function runBenchmark() {
    local serviceScript="$1"
    killServerOnPort 8000

    if [[ "$serviceScript" == *"hasura"* ]]; then
        bash "$serviceScript" # Run synchronously without background process
        graphqlEndpoint=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' graphql-engine):8080/v1/graphql
    else
        bash "$serviceScript" & # Run in daemon mode
        graphqlEndpoint="http://localhost:8000/graphql"
    fi

    waitForService "$graphqlEndpoint"

    # Replace / with _
    local sanitizedServiceScriptName=$(echo "$serviceScript" | tr '/' '_')

    # Run benchmarks
    runBenchmarks "$serviceScript" "$graphqlEndpoint" "$sanitizedServiceScriptName"

    # Clean up
    if [ "$serviceScript" == "graphql/apollo_server/run.sh" ]; then
        cd graphql/apollo_server/ && npm stop && cd ../../
    elif [ "$serviceScript" == "graphql/hasura/run.sh" ]; then
        bash "graphql/hasura/kill.sh"
    else
        killServerOnPort 8000
    fi
}

# Main execution
if [ $# -eq 0 ]; then
    echo "Usage: $0 <server_name>"
    echo "Available servers: apollo_server, caliban, netflix_dgs, gqlgen, tailcall, async_graphql, hasura, graphql_jit"
    exit 1
fi

server="$1"
serviceScript="graphql/${server}/run.sh"

if [ ! -f "$serviceScript" ]; then
    echo "Error: Server script not found for $server"
    exit 1
fi

killServerOnPort 3000
sh nginx/run.sh
rm -f results.md
runBenchmark "$serviceScript"