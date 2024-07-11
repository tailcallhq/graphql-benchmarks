#!/bin/bash
set -e

# Function to find an available port
find_available_port() {
  local port=8000
  while netstat -tna | grep -q :$port; do
    ((port++))
  done
  echo $port
}

# Function to run a single benchmark
run_benchmark() {
  local service=$1
  local port=$(find_available_port)
  local log_file="benchmark_${service}.log"
  echo "Starting benchmark for $service on port $port"

  # Stop and remove any existing containers
  docker stop $(docker ps -a -q --filter name=$service) 2>/dev/null || true
  docker rm $(docker ps -a -q --filter name=$service) 2>/dev/null || true

  # Start the service
  if [[ "$service" == "hasura" ]]; then
    PORT=$port bash "graphql/${service}/run.sh" > "$log_file" 2>&1
    graphql_endpoint="http://$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' graphql-engine):8080/v1/graphql"
  else
    PORT=$port bash "graphql/${service}/run.sh" > "$log_file" 2>&1 &
    graphql_endpoint="http://localhost:$port/graphql"
  fi

  # Wait for service to start (adjust timeout as needed)
  local timeout=60
  while ! curl -s "$graphql_endpoint" > /dev/null; do
    sleep 1
    ((timeout--))
    if [ $timeout -le 0 ]; then
      echo "Service $service failed to start within the timeout period"
      return 1
    fi
  done

  # Run benchmarks
  for bench in 1 2 3; do
    echo "Running benchmark $bench for $service"
    bash "test_query${bench}.sh" "$graphql_endpoint"

    # Warmup run
    bash "wrk/bench.sh" "$graphql_endpoint" "$bench" >/dev/null
    sleep 5

    # Actual benchmark runs
    for run in {1..5}; do
      bash "wrk/bench.sh" "$graphql_endpoint" "$bench" > "bench${bench}_${service}_run${run}.txt"
      sleep 5
    done
  done

  # Stop the service
  if [[ "$service" == "hasura" ]]; then
    bash "graphql/hasura/kill.sh"
  elif [[ "$service" == "apollo_server" ]]; then
    cd graphql/apollo_server/
    npm stop
    cd ../../
  else
    killall node java go rust 2>/dev/null || true
  fi

  echo "Finished benchmark for $service"
}

# Main script
service=$1
if [ -z "$service" ]; then
  echo "Usage: $0 <service_name>"
  exit 1
fi

run_benchmark "$service"

echo "Benchmark completed for $service"