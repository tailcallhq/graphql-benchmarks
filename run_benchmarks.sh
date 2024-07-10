#!/bin/bash

# Function to create a Docker network if it doesn't exist
function create_docker_network() {
    if ! docker network inspect graphql_benchmark_network >/dev/null 2>&1; then
        docker network create graphql_benchmark_network
    fi
}

# Function to run a service in a Docker container
function run_service_in_docker() {
    local service_name="$1"
    local docker_file="graphql/${service_name}/Dockerfile"
    local container_name="graphql_${service_name}"

    # Build the Docker image
    docker build -t "${container_name}" -f "${docker_file}" .

    # Run the container
    docker run --rm -d --name "${container_name}" --network graphql_benchmark_network "${container_name}"

    # Wait for the service to start
    sleep 15
}

# Function to run benchmarks
function run_benchmark() {
    local service_name="$1"
    local container_name="graphql_${service_name}"
    local benchmarks=(1 2 3)
    local graphql_endpoint="http://${container_name}:8000/graphql"

    if [[ "$service_name" == "hasura" ]]; then
        graphql_endpoint="http://${container_name}:8080/v1/graphql"
    fi

    for bench in "${benchmarks[@]}"; do
        local benchmark_script="wrk/bench.sh"
        local result_file="result${bench}_${service_name}.txt"

        # Run test query
        docker run --rm --network graphql_benchmark_network -v "$(pwd)/test_query${bench}.sh:/test_query.sh" alpine sh /test_query.sh "${graphql_endpoint}"

        # Warmup run
        docker run --rm --network graphql_benchmark_network -v "$(pwd)/${benchmark_script}:/bench.sh" alpine sh /bench.sh "${graphql_endpoint}" "${bench}" >/dev/null
        sleep 1

        # 3 benchmark runs
        for i in {1..3}; do
            echo "Running benchmark $bench for $service_name (run $i)"
            docker run --rm --network graphql_benchmark_network -v "$(pwd)/${benchmark_script}:/bench.sh" alpine sh /bench.sh "${graphql_endpoint}" "${bench}" > "bench${bench}_${result_file}_${i}"
        done
    done
}

# Main script execution
create_docker_network

rm -f results.md

services=("apollo_server" "caliban" "netflix_dgs" "gqlgen" "tailcall" "async_graphql" "hasura" "graphql_jit")

for service in "${services[@]}"; do
    run_service_in_docker "${service}"
    run_benchmark "${service}"
    docker stop "graphql_${service}"
done

# Run analysis (you may need to adjust this part based on your analysis script)
bash analyze.sh bench*_result*.txt

# Clean up
docker network rm graphql_benchmark_network
