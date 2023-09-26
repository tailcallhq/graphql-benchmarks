#!/bin/bash
curl -sSL https://raw.githubusercontent.com/tailcallhq/tailcall/main/install.sh | bash -s -- v0.9.0
export PATH=$PATH:~/.tailcall/bin
current_dir=$(pwd)
$HOME/.tailcall/bin/tc start $current_dir/graphql/tailcall/benchmark.graphql