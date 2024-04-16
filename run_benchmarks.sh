#!/bin/bash

# Function to kill a server running on a specific port
function killServerOnPort() {
  local port="$1"
  local pid=$(lsof -t -i:"$port")
  if [ -n "$pid" ]; then
    kill "$pid" && echo "Killed process running on port $port" || echo "Failed to kill process on port $port"
  else
    echo "No process found running on port $port"
  fi
}

allResults=()
killServerOnPort 3000
sh nginx/run.sh

# URL of the server to test
url="http://localhost:8000/graphql"

# Function to fetch the Date header using curl
fetch_date() {
  curl -i -X POST -d '{"query": "{posts{title}}"}' -H "Content-Type: application/json" "$url" | grep -i "^date:" | tr -d '\r'
}

# Function to validate that the Date header changes every second
validate_date_change() {
  local first_date=$(fetch_date)
  echo "First Date: $first_date"
  if [ -z "$first_date" ]; then
    echo "Error: Date header is missing in the response."
    return 0 # Failure
  fi

  sleep 1
  local second_date=$(fetch_date)
  echo "Second Date: $second_date"
  if [ "$first_date" = "$second_date" ]; then
    echo "Error: Date header did not change."
    return 0 # Failure
  else
    echo "Success: Date header changes every second."
    return 1 # Success
  fi
}

function runBenchmark() {
  local serviceScript="$1"
  killServerOnPort 8000
  sleep 5
  bash "$serviceScript" & # Start the server
  sleep 15                # Wait for the server to start

  if validate_date_change; then
    local benchmarkScript="wrk/bench.sh"
    local resultFiles=("result1_${serviceScript}.txt" "result2_${serviceScript}.txt" "result3_${serviceScript}.txt")

    # Warmup phase
    bash "$benchmarkScript" >/dev/null # Warmup run to stabilize performance
    sleep 1                            # Short pause between warmup and actual benchmark

    # Warmup phase
    bash "$benchmarkScript" >/dev/null # Warmup run to stabilize performance
    sleep 1                            # Short pause between warmup and actual benchmark

    # Warmup phase
    bash "$benchmarkScript" >/dev/null # Warmup run to stabilize performance
    sleep 1                            # Short pause between warmup and actual benchmark

    # Actual benchmarking
    for resultFile in "${resultFiles[@]}"; do
      bash "$benchmarkScript" >"$resultFile"
      allResults+=("$resultFile")
    done
  fi
}

# Run benchmarks for each service
for script in "graphql/apollo_server/run.sh" "graphql/caliban/run.sh" "graphql/netflix_dgs/run.sh" "graphql/gqlgen/run.sh" "graphql/tailcall/run.sh" "graphql/async_graphql/run.sh"; do
  runBenchmark "$script"
done

# Analyze all results
bash analyze.sh "${allResults[@]}"
