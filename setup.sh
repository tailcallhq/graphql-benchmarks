#!/bin/bash

# Ensure you're in the workspace directory
cd /workspace

# For gqlgen:
cd graphql/gqlgen
go build -o main main.go

# For apollo-server:
cd /workspace/graphql/apollo-server
npm i

# For netflix dgs
cd /workspace/graphql/netflixdgs
./gradlew build

# For tailcall:
curl -sSL https://raw.githubusercontent.com/tailcallhq/tailcall/main/install.sh | bash -s -- v0.9.0
export PATH=$PATH:/root/.tailcall/bin
