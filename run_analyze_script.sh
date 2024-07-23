#!/bin/bash

# Update and install gnuplot
sudo apt-get update && sudo apt-get install -y gnuplot

# Remove existing results file
rm -f results.md

services=("apollo" "caliban" "netflixdgs" "gqlgen" "tailcall" "async_graphql" "hasura" "graphql_jit")

# Loop through each benchmark (1, 2, 3)
for bench in 1 2 3; do
    echo "Processing files for bench${bench}:"
    
    # Construct the command for each benchmark
    cmd="bash analyze.sh"
    
    # Loop through each service 
    for service in "${services[@]}"; do
        # Convert service name to match file naming convention 
        case $service in
            "apollo") file_service="apollo_server" ;;
            "netflixdgs") file_service="netflix_dgs" ;;
            *) file_service=$service ;;
        esac
        
        # Add files for current service to the command
        for run in 1 2 3; do
            cmd+=" bench${bench}_result${run}_graphql_${file_service}_run.sh.txt"
        done
    done
    
    # Execute the command
    echo "Executing: $cmd"
    eval $cmd
done