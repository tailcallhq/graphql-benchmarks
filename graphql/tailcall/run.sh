#!/bin/bash
current_dir=$(pwd)
$HOME/.tailcall/bin/tc start --graphql /graphql/tailcall/benchmark.graphql --port 8000
