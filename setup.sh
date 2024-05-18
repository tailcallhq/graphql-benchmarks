#!/bin/bash
echo 0 | sudo tee /proc/sys/kernel/kptr_restrict
echo -1 | sudo tee /proc/sys/kernel/perf_event_paranoid

# Install necessary tools
sudo apt-get update
sudo apt-get install -y linux-tools-common linux-tools-generic linux-tools-$(uname -r)

# For gqlgen:
cd graphql/gqlgen
go build -o main main.go
cd ../../
# For apollo server:
cd graphql/apollo_server
npm i
cd ../../

# For netflix dgs
cd graphql/netflix_dgs
./gradlew build
cd ../../

# For tailcall:
cd graphql/tailcall
npm install
cd ../../

# For caliban
cd graphql/caliban
./sbt compile
cd ../../

# For async-graphql
./graphql/async_graphql/build.sh
cd ../../
