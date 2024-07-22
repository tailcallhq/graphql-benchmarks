#!/bin/bash

function run_setup_gqlgen() {
    # For gqlgen:
    cd graphql/gqlgen
    go build -o main main.go
    cd ../../
}

function run_setup_apollo_server() {
    # For apollo server:
    cd graphql/apollo_server
    npm i
    cd ../../
}

function run_setup_netflix_dgs() {
    # For netflix dgs
    cd graphql/netflix_dgs
    ./gradlew build
    cd ../../
}

function run_setup_tailcall() {
    # For tailcall:
    cd graphql/tailcall
    npm install
    cd ../../
}

function run_setup_caliban() {
    # For caliban
    cd graphql/caliban
    ./sbt compile
    cd ../../
}

function run_setup_graphql() {
    # For async-graphql
    ./graphql/async_graphql/build.sh
}

function run_setup_hasura() {
    # For hasura
    cd graphql/hasura
    npm install
    cd ../../
}

function run_setup_graphql_jit() {
    # For graphql_jit
    cd graphql/graphql_jit
    npm install
    cd ../../
}

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

function run_pre_setup() {
    killServerOnPort 3000
    killServerOnPort 8000
    sh nginx/run.sh
}


# setup
echo "Benchmarking Setup started ...."
benchmark_candidate=$1
echo "Setting up ${benchmark_candidate} project ...... "
run_pre_setup
"run_setup_${benchmark_candidate}"
echo "Benchmarking Setup Finished ...."