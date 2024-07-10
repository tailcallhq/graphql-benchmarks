#!/bin/bash

# Start services and run benchmarks in parallel

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

killServerOnPort 3000
sh nginx/run.sh

function runBenchmark() {
    local serviceScript="$1"
    local serviceName=$(basename "$serviceScript" .sh)
    local benchmarks=(1 2 3)
    local graphqlEndpoint="http://localhost:8000/graphql"

    killServerOnPort 8000
    sleep 5

    if [[ "$serviceScript" == *"hasura"* ]]; then
        bash "$serviceScript" # Run synchronously without background process
        graphqlEndpoint=http://$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' graphql-engine):8080/v1/graphql
    else
        bash "$serviceScript" & # Run in daemon mode
    fi

    sleep 15 # Give some time for the service to start up

    for bench in "${benchmarks[@]}"; do
        local benchmarkScript="wrk/bench.sh"
        local resultFile="result_${serviceName}_bench${bench}.txt"

        bash "test_query${bench}.sh" "$graphqlEndpoint"
        
        # Warmup run
        bash "$benchmarkScript" "$graphqlEndpoint" "$bench" >/dev/null
        sleep 1

        # Actual benchmark run
        echo "Running benchmark $bench for $serviceName"
        bash "$benchmarkScript" "$graphqlEndpoint" "$bench" > "$resultFile"
    done

    if [[ "$serviceScript" == *"apollo_server"* ]]; then
        cd graphql/apollo_server/
        npm stop
        cd ../../
    elif [[ "$serviceScript" == *"hasura"* ]]; then
        bash "graphql/hasura/kill.sh"
    else
        killServerOnPort 8000
    fi
}

rm "results.md"

services=("apollo_server" "caliban" "netflix_dgs" "gqlgen" "tailcall" "async_graphql" "hasura" "graphql_jit")

# Run benchmarks for all services in parallel
for service in "${services[@]}"; do
    runBenchmark "graphql/${service}/run.sh" &
done

# Wait for all background processes to finish
wait

# Analyze results
for bench in 1 2 3; do
    resultFiles=()
    for service in "${services[@]}"; do
        resultFiles+=("result_${service}_bench${bench}.txt")
    done
    bash analyze.sh "${resultFiles[@]}"
done