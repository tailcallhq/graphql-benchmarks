#!/bin/bash

set -e

# Function to run a single benchmark in its own environment
run_benchmark() {
  local service=$1
  local port=8000
  local log_file="benchmark_${service}.log"

  echo "Starting benchmark for $service"

  # Create a new directory for this benchmark
  mkdir -p "benchmark_${service}"
  cd "benchmark_${service}"

  # Copy necessary files
  cp -r ../graphql .
  cp -r ../wrk .
  cp ../test_query*.sh .
  cp ../analyze.sh .

  # Start the service
  if [[ "$service" == "hasura" ]]; then
    bash "graphql/${service}/run.sh" > "$log_file" 2>&1
    graphql_endpoint="http://$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' graphql-engine):8080/v1/graphql"
  else
    bash "graphql/${service}/run.sh" > "$log_file" 2>&1 &
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
    sleep 1
    # Actual benchmark runs
    for run in {1..3}; do
      bash "wrk/bench.sh" "$graphql_endpoint" "$bench" > "bench${bench}_${service}_run${run}.txt"
      sleep 1
    done
  done

  # Analyze results
  for bench in 1 2 3; do
    bash analyze.sh bench${bench}_*.txt > "results_bench${bench}.md"
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

  # Return to the original directory
  cd ..
}

# Main script
rm -f results.md

# Array of services to benchmark
services=("apollo_server" "caliban" "netflix_dgs" "gqlgen" "tailcall" "async_graphql" "hasura" "graphql_jit")

# Run benchmarks in separate environments
for service in "${services[@]}"; do
  run_benchmark "$service"
done

# Combine results
echo "# Combined Benchmark Results" > results.md
for service in "${services[@]}"; do
  echo "## $service" >> results.md
  for bench in 1 2 3; do
    cat "benchmark_${service}/results_bench${bench}.md" >> results.md
    echo "" >> results.md
  done
done

echo "All benchmarks completed"