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

  if [[ "$serviceScript" == *"hasura"* ]]; then
    bash "$serviceScript" # Run synchronously without background process
  else
    bash "$serviceScript" & # Run in daemon mode
  fi

  sleep 15 # Give some time for the service to start up

  local graphqlEndpoint="http://localhost:8000/graphql"
  if [[ "$serviceScript" == *"hasura"* ]]; then
    graphqlEndpoint=http://127.0.0.1:8080/v1/graphql
  fi

  # Replace / with _
  local sanitizedServiceScriptName=$(echo "$serviceScript" | tr '/' '_')

  # Function to run a single benchmark
  function runSingleBenchmark() {
    local bench="$1"
    local benchmarkScript="wrk/bench.sh"
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
  }

  # Run benchmarks in parallel
  runSingleBenchmark 1 &
  runSingleBenchmark 2 &
  runSingleBenchmark 3 &

  # Wait for all benchmarks to complete
  wait
}

rm "results.md"

# Main script
if [ $# -eq 0 ]; then
    echo "Usage: $0 <service_name>"
    echo "Available services: apollo_server, caliban, netflix_dgs, gqlgen, tailcall, async_graphql, hasura, graphql_jit"
    exit 1
fi  

service="$1"
valid_services=("apollo_server" "caliban" "netflix_dgs" "gqlgen" "tailcall" "async_graphql" "hasura" "graphql_jit")

if [[ ! " ${valid_services[@]} " =~ " ${service} " ]]; then
    echo "Invalid service name. Available services: ${valid_services[*]}"
    exit 1
fi

runBenchmark "graphql/${service}/run.sh"

if [ "$service" == "apollo_server" ]; then
    cd graphql/apollo_server/
    npm stop
    cd ../../
elif [ "$service" == "hasura" ]; then
    bash "graphql/hasura/kill.sh"
fi