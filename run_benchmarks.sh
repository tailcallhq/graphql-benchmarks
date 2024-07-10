#!/bin/bash

# Function to find an available port
find_available_port() {
  local port=8000
  while nc -z localhost $port; do
    ((port++))
  done
  echo $port
}

# Function to run benchmark for a specific service and query
function runBenchmark() {
  local serviceScript="$1"
  local queryNum="$2"
  local resultFile="result${queryNum}_$(echo "$serviceScript" | tr '/' '_').txt"

  local port=$(find_available_port)
  
  if [[ "$serviceScript" == *"hasura"* ]]; then
    bash "$serviceScript" # Run synchronously without background process
  else
    PORT=$port bash "$serviceScript" & # Run in daemon mode with specific port
  fi
  
  sleep 15 # Give some time for the service to start up

  local graphqlEndpoint="http://localhost:$port/graphql"
  if [[ "$serviceScript" == *"hasura"* ]]; then
    graphqlEndpoint=http://$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' graphql-engine):8080/v1/graphql
  fi

  local benchmarkScript="wrk/bench.sh"

  # Warmup run
  bash "test_query${queryNum}.sh" "$graphqlEndpoint"
  bash "$benchmarkScript" "$graphqlEndpoint" "$queryNum" >/dev/null
  sleep 1

  # Actual benchmark run
  echo "Running benchmark $queryNum for $serviceScript on port $port"
  bash "$benchmarkScript" "$graphqlEndpoint" "$queryNum" >"bench${queryNum}_${resultFile}"

  # Clean up
  if [ "$serviceScript" == "graphql/apollo_server/run.sh" ]; then
    cd graphql/apollo_server/
    npm stop
    cd ../../
  elif [ "$serviceScript" == "graphql/hasura/run.sh" ]; then
    bash "graphql/hasura/kill.sh"
  else
    kill $(lsof -t -i:$port) 2>/dev/null
  fi
}

# Main execution
rm -f "results.md"

services=("apollo_server" "caliban" "netflix_dgs" "gqlgen" "tailcall" "async_graphql" "hasura" "graphql_jit")

# Run benchmarks for each query type in parallel
for queryNum in 1 2 3; do
  for service in "${services[@]}"; do
    runBenchmark "graphql/${service}/run.sh" "$queryNum" &
  done
  wait # Wait for all background processes to finish before moving to the next query type
done

# Analyze results
for queryNum in 1 2 3; do
  resultFiles=($(ls bench${queryNum}_result${queryNum}_*.txt 2>/dev/null))
  if [ ${#resultFiles[@]} -gt 0 ]; then
    bash analyze.sh "${resultFiles[@]}"
  else
    echo "No result files found for query $queryNum"
  fi
done