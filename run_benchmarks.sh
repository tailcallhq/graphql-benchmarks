#!/bin/bash

# Function to kill a server on a specific port
function killServerOnPort() {
  local port="$1"
  local pids=$(lsof -t -i:"$port")
  if [ -n "$pids" ]; then
    echo "$pids" | xargs kill
    echo "Killed process(es) running on port $port"
  else
    echo "No process found running on port $port"
  fi
}

# Function to get an available port
get_available_port() {
    local port=8000
    while lsof -i:$port >/dev/null 2>&1; do
        ((port++))
    done
    echo $port
}

# Function to run benchmarks for a single service
function runBenchmarkForService() {
  local serviceScript="$1"
  local serviceName=$(basename "$serviceScript" .sh)
  
  local port=$(get_available_port)
  export SERVICE_PORT=$port

  if [[ "$serviceScript" == *"hasura"* ]]; then
    bash "$serviceScript" # Run synchronously without background process
  else
    bash "$serviceScript" & # Run in daemon mode
  fi
  
  sleep 15 # Give some time for the service to start up

  local graphqlEndpoint="http://localhost:$port/graphql"
  if [[ "$serviceScript" == *"hasura"* ]]; then
    graphqlEndpoint=http://$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' graphql-engine):8080/v1/graphql
  fi

  # Run benchmarks in order: greet, list of posts, posts with users
  for bench in 1 2 3; do
    local benchmarkScript="wrk/bench.sh"
    local resultFile="result${bench}_${serviceName}.txt"
    
    bash "test_query${bench}.sh" "$graphqlEndpoint"
    
    # Warmup run
    bash "$benchmarkScript" "$graphqlEndpoint" "$bench" >/dev/null
    sleep 1
    
    # Actual benchmark run
    echo "Running benchmark $bench for $serviceName"
    bash "$benchmarkScript" "$graphqlEndpoint" "$bench" >"bench${bench}_${resultFile}"
    
    # Add result to the appropriate array
    if [ "$bench" == "1" ]; then
      bench1Results+=("bench1_${resultFile}")
    elif [ "$bench" == "2" ]; then
      bench2Results+=("bench2_${resultFile}")
    elif [ "$bench" == "3" ]; then
      bench3Results+=("bench3_${resultFile}")
    fi
  done

  # Clean up after benchmarks
  if [ "$serviceName" == "apollo_server" ]; then
    cd graphql/apollo_server/
    npm stop
    cd ../../
  elif [ "$serviceName" == "hasura" ]; then
    bash "graphql/hasura/kill.sh"
  else
    killServerOnPort $port
  fi
}

# Initialize result arrays
bench1Results=()
bench2Results=()
bench3Results=()

# Kill any existing server on port 3000
killServerOnPort 3000

# Ensure the nginx log directory exists
mkdir -p /workspaces/graphql-benchmarks/nginx

# Start nginx
sudo nginx -c /workspaces/graphql-benchmarks/nginx/nginx.conf

# Remove existing results file
rm -f "results.md"

# Stop and remove existing Docker containers
docker stop $(docker ps -aq) || true
docker rm $(docker ps -aq) || true

# Run benchmarks for each service in parallel
services=("apollo_server" "caliban" "netflix_dgs" "gqlgen" "tailcall" "async_graphql" "hasura" "graphql_jit")
for service in "${services[@]}"; do
  runBenchmarkForService "graphql/${service}/run.sh" &
done

# Wait for all background processes to finish
wait

# Analyze results
bash analyze.sh "${bench1Results[@]}"
bash analyze.sh "${bench2Results[@]}"
bash analyze.sh "${bench3Results[@]}"
