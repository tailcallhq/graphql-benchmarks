#!/bin/bash

# Function to kill a process running on a specific port
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

# Function to run benchmarks for a single GraphQL server
function runBenchmark() {
    local serviceScript="$1"
    local serviceName=$(basename "$serviceScript" .sh)
    local benchmarks=(1 2 3)
    local graphqlEndpoint="http://localhost:8000/graphql"

    echo "Starting $serviceName server..."
    
    # Start the server
    if [[ "$serviceScript" == *"hasura"* ]]; then
        bash "$serviceScript"
        graphqlEndpoint=http://$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' graphql-engine):8080/v1/graphql
    else
        bash "$serviceScript" &
    fi

    # Wait for server to start
    sleep 15

    # Run benchmarks
    for bench in "${benchmarks[@]}"; do
        local benchmarkScript="wrk/bench.sh"
        local resultFile="result_${serviceName}_bench${bench}.txt"

        # Warmup run
        bash "test_query${bench}.sh" "$graphqlEndpoint"
        bash "$benchmarkScript" "$graphqlEndpoint" "$bench" >/dev/null
        sleep 1

        # Actual benchmark run
        echo "Running benchmark $bench for $serviceName"
        bash "$benchmarkScript" "$graphqlEndpoint" "$bench" > "$resultFile"
    done

    # Stop the server
    if [[ "$serviceScript" == *"apollo_server"* ]]; then
        cd graphql/apollo_server/
        npm stop
        cd ../../
    elif [[ "$serviceScript" == *"hasura"* ]]; then
        bash "graphql/hasura/kill.sh"
    else
        killServerOnPort 8000
    fi

    echo "Finished benchmarking $serviceName"
    sleep 5  # Wait a bit before starting the next server
}

# Main execution
rm -f results.md
killServerOnPort 3000
sh nginx/run.sh

services=("apollo_server" "caliban" "netflix_dgs" "gqlgen" "tailcall" "async_graphql" "hasura" "graphql_jit")

for service in "${services[@]}"; do
    runBenchmark "graphql/${service}/run.sh"
done

# Analyze results
for bench in 1 2 3; do
    resultFiles=($(ls result_*_bench${bench}.txt))
    bash analyze.sh "${resultFiles[@]}"
done