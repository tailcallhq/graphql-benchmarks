#!/bin/bash
current_dir=$(pwd)
TAILCALL_LOG_LEVEL=error TC_TRACKER=false $HOME/.tailcall/bin/tailcall start $current_dir/graphql/tailcall/benchmark.graphql
