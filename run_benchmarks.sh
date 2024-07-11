#!/bin/bash
set -e

service=$1
port=$(find_available_port)
log_file="benchmark_${service}.log"

echo "Starting benchmark for $service on port $port"

# Function to run a single benchmark
run_benchmark() {
  local query=$1
  local endpoint=$2

  echo "Running $query query for $service"
  bash "test_${query}.sh" "$endpoint"
  
  # Warmup run
  bash "wrk/bench.sh" "$endpoint" "$query" >/dev/null
  sleep 1

  # Actual benchmark runs
  for run in {1..3}; do
    bash "wrk/bench.sh" "$endpoint" "$query" > "${query}_${service}_run${run}.txt"
    sleep 1
  done
}

# Start the service
if [[ "$service" == "hasura" ]]; then
  PORT=$port bash "graphql/${service}/run.sh" > "$log_file" 2>&1
  graphql_endpoint="http://$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' graphql-engine):8080/v1/graphql"
else
  PORT=$port bash "graphql/${service}/run.sh" > "$log_file" 2>&1 &
  graphql_endpoint="http://localhost:$port/graphql"
fi

# Wait for service to start
timeout=60
while ! curl -s "$graphql_endpoint" > /dev/null; do
  sleep 1
  ((timeout--))
  if [ $timeout -le 0 ]; then
    echo "Service $service failed to start within the timeout period"
    exit 1
  fi
done

# Run benchmarks in the specified order
run_benchmark "greet" "$graphql_endpoint"
run_benchmark "posts" "$graphql_endpoint"
run_benchmark "posts_with_users" "$graphql_endpoint"

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

# Analyze results
for query in greet posts posts_with_users; do
  bash analyze.sh ${query}_${service}_*.txt >> "results_${service}.md"
done

echo "Benchmark completed for $service"