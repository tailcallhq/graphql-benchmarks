#!/bin/bash

# Base directory

cd graphql/tailcall

current_dir=$(pwd)
echo "Current directory: $current_dir"

base_dir="./node_modules"

# Pick the tailcall executable
for core_dir in $(find "$base_dir" -type d -name "core-*"); do
    tailcall_executable="${core_dir}/bin/tailcall"

    # Check if the tailcall executable exists
    if [[ -x "$tailcall_executable" ]]; then
        echo "Executing $tailcall_executable"

        # Run the executable with the specified arguments
        TAILCALL_LOG_LEVEL=error TC_TRACKER=false "$tailcall_executable" start $current_dir/benchmark.graphql
        exit 0
    fi
done

echo "tailcall executable not found."
exit 1