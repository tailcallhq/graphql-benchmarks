#!/bin/bash

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

# For hasura
cd graphql/hasura
npm install
cd ../../

# For graphql_jit
cd graphql/graphql_jit
npm install
cd ../../

# install oha if rust is installed
if command -v rustc >/dev/null 2>&1; then
  cargo install oha
else
  echo "Rust is not installed. Skipping oha installation."
fi
