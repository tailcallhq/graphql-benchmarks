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
  # Fetch the Date header for the first time
  local first_date=$(fetch_date)
  echo "First Date: $first_date"

  # Ensure that the Date header is not empty
  if [ -z "$first_date" ]; then
    echo "Error: Date header is missing in the response."
    return 0 # Indicates failure
  fi

  # Sleep for a second to ensure the next Date header should be different
  sleep 1

  # Fetch the Date header for the second time
  local second_date=$(fetch_date)
  echo "Second Date: $second_date"

  # Compare the two Date headers
  if [ "$first_date" = "$second_date" ]; then
    echo "Error: Date header did not change."
    return 0 # Indicates failure
  else
    echo "Success: Date header changes every second."
    return 1 # Indicates success
  fi
}

function runBenchmark() {
  killServerOnPort 8000
  sleep 5
  local serviceScript="$1"
  local benchmarkScript="wrk/bench.sh"

  # Replace / with _
  local sanitizedServiceScriptName=$(echo "$serviceScript" | tr '/' '_')

  local resultFiles=("result1_${sanitizedServiceScriptName}.txt" "result2_${sanitizedServiceScriptName}.txt" "result3_${sanitizedServiceScriptName}.txt")

  bash "$serviceScript" & # Run in daemon mode
  sleep 15                # Give some time for the service to start up

  bash "test_query.sh"

  if validate_date_change; then
    echo "Error: Date header did not change every second."
    # Warmup run
    bash "$benchmarkScript" >/dev/null
    sleep 1 # Give some time for apps to finish in-flight requests from warmup
    bash "$benchmarkScript" >/dev/null
    sleep 1
    bash "$benchmarkScript" >/dev/null
    sleep 1

    # 3 benchmark runs
    for resultFile in "${resultFiles[@]}"; do
      bash "$benchmarkScript" >"$resultFile"
      allResults+=("$resultFile")
    done
  fi
}

runBenchmark "graphql/apollo_server/run.sh"
cd graphql/apollo_server/
npm stop
cd ../../

runBenchmark "graphql/caliban/run.sh"

runBenchmark "graphql/netflix_dgs/run.sh"

runBenchmark "graphql/gqlgen/run.sh"

runBenchmark "graphql/tailcall/run.sh"

runBenchmark "graphql/async_graphql/run.sh"

# Now, analyze all results together
bash analyze.sh "${allResults[@]}"
