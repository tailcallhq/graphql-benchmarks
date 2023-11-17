#!/bin/bash
pwd
cd graphql/gqlgen
go build -o main main.go
./main -port 8000
