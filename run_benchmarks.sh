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

  # Start the service using the existing run script
  PORT=$port bash "graphql/${service}/run.sh" > "$log_file" 2>&1 &
  local service_pid=$!

  # Determine the GraphQL endpoint
  if [[ "$service" == "hasura" ]]; then
    graphql_endpoint="http://$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' graphql-engine):8080/v1/graphql"
  else
    graphql_endpoint="http://localhost:$port/graphql"
  fi

  # Wait for service to start (adjust timeout as needed)
  local timeout=120  # Increased timeout to 2 minutes
  while ! curl -s "$graphql_endpoint" > /dev/null; do
    sleep 1
    ((timeout--))
    if [ $timeout -le 0 ]; then
      echo "Service $service failed to start within the timeout period"
      echo "Last 20 lines of log file:"
      tail -n 20 "$log_file"
      echo "Attempting to kill the service process..."
      kill $service_pid 2>/dev/null || true
      return 1
    fi
    # Check if the service process is still running
    if ! kill -0 $service_pid 2>/dev/null; then
      echo "Service $service process has died. Check the log file for details."
      echo "Last 20 lines of log file:"
      tail -n 20 "$log_file"
      return 1
    fi
  done

  echo "Service $service started successfully"

  # Run benchmarks
  for bench in 1 2 3; do
    echo "Running benchmark $bench for $service"
    bash "test_query${bench}.sh" "$graphql_endpoint"
    # Warmup run
    bash "wrk/bench.sh" "$graphql_endpoint" "$bench" >/dev/null
    sleep 1
    # Actual benchmark runs
    for run in {1..3}; do
      bash "wrk/bench.sh" "$graphql_endpoint" "$bench" > "bench${bench}_${service}_run${run}.txt"
      sleep 1
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
    kill $service_pid 2>/dev/null || true
    killall node java go rust 2>/dev/null || true
  fi

  echo "Finished benchmark for $service"
}

# Main script
rm -f results.md

# Array of services to benchmark
services=("apollo_server" "caliban" "netflix_dgs" "gqlgen" "tailcall" "async_graphql" "hasura" "graphql_jit")

# Run benchmarks sequentially
for service in "${services[@]}"; do
  if run_benchmark "$service"; then
    echo "Benchmark for $service completed successfully"
  else
    echo "Benchmark for $service failed"
  fi
done

# Analyze results
for bench in 1 2 3; do
  bash analyze.sh bench${bench}_*.txt
done

echo "All benchmarks completed"
