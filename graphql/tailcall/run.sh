#!/bin/bash
current_dir=$(pwd)
TAILCALL_LOG_LEVEL=error $HOME/Code/tailcall/target/release/tailcall start $current_dir/graphql/tailcall/benchmark.graphql
