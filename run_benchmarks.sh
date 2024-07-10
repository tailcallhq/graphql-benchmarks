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

# Function to run benchmarks for a single service
function runBenchmark() {
  local serviceScript="$1"
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

  local sanitizedServiceScriptName=$(echo "$serviceScript" | tr '/' '_')

  for bench in {1..3}; do
    local benchmarkScript="wrk/bench.sh"
    local resultFile="result${bench}_${sanitizedServiceScriptName}.txt"

    # Run the query test
    bash "test_query${bench}.sh" "$graphqlEndpoint"

    # Warmup run
    bash "$benchmarkScript" "$graphqlEndpoint" "$bench" >/dev/null
    sleep 1

    # Actual benchmark run
    echo "Running benchmark $bench for $serviceScript"
    bash "$benchmarkScript" "$graphqlEndpoint" "$bench" >"bench${bench}_${resultFile}"

    # Add result to the appropriate array
    eval "bench${bench}Results+=(\"bench${bench}_${resultFile}\")"
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

# Main script execution
killServerOnPort 3000
sh nginx/run.sh

rm "results.md"

# Array to store all benchmark processes
benchmarkProcesses=()

# Start all benchmarks in parallel
for service in "apollo_server" "caliban" "netflix_dgs" "gqlgen" "tailcall" "async_graphql" "hasura" "graphql_jit"; do
  runBenchmark "graphql/${service}/run.sh" &
  benchmarkProcesses+=($!)
done

# Wait for all benchmark processes to complete
for pid in "${benchmarkProcesses[@]}"; do
  wait $pid
done

# Analyze results
for bench in {1..3}; do
  eval "bash analyze.sh \"\${bench${bench}Results[@]}\""
done
