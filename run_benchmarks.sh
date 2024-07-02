#!/bin/bash

# Kills any server running on the given port
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

allResults=()

# Initial server kill in case any are running
killServerOnPort 3000
sh nginx/run.sh

# URL of the server to test
url="http://localhost:8000/graphql"

# Fetches the Date header using curl
fetch_date() {
  curl -i -X POST -d '{"query": "{posts{title}}"}' -H "Content-Type: application/json" "$url" | grep -i "^date:" | tr -d '\r'
}

# Validates that the Date header changes every second
validate_date_change() {
  local first_date=$(fetch_date)
  echo "First Date: $first_date"
  if [ -z "$first_date" ]; then
    echo "Error: Date header is missing in the response."
    return 0 # Failure
  fi

  sleep 2
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

# Function to run the benchmark on a given service script
function runBenchmark() {
  killServerOnPort 8000
  sleep 5
  local serviceScript="$1"
  echo "Running benchmark for $serviceScript"
  local serviceName=$(echo "$serviceScript" | tr '/' '_') # Get a simple name for the service
  echo $serviceName

  bash "$serviceScript" & # Start the server
  sleep 15                # Wait for the server to start

  if ! validate_date_change; then
    local benchmarkScript="wrk/bench.sh"
    local resultFiles=()
    for i in {1..3}; do
      bash "$benchmarkScript" >/dev/null
      sleep 1
    done

    for i in {1..3}; do
      local resultFile="result${i}_${serviceName}.txt"
      bash "$benchmarkScript" >"$resultFile"
      resultFiles+=("$resultFile")
    done
    allResults+=("${resultFiles[@]}")
  else
    echo "Skipping results collection for $serviceName due to failed date header validation."
  fi
}

runBenchmark "graphql/apollo_server/run.sh"
cd graphql/apollo_server/
npm stop
cd ../../

# Run benchmarks for each specified service
for script in "graphql/caliban/run.sh" "graphql/netflix_dgs/run.sh" "graphql/gqlgen/run.sh" "graphql/tailcall/run.sh" "graphql/async_graphql/run.sh"; do
  runBenchmark "$script"
done

# Analyze all successful results
bash analyze.sh "${allResults[@]}"
