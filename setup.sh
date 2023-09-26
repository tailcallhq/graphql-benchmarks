#!/bin/bash

# For gqlgen:
cd graphql/gqlgen
go build -o main main.go
cd ../../
# For apollo-server:
cd graphql/apollo-server
npm i
cd ../../

# For netflix dgs
cd graphql/netflixdgs
./gradlew build
cd ../../

# For tailcall:
curl -sSL https://raw.githubusercontent.com/tailcallhq/tailcall/main/install.sh | bash -s -- v0.9.0
export PATH=$PATH:/root/.tailcall/bin
