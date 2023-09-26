#!/bin/bash
ulimit -n 1000000

# Get the present working directory
current_dir=$(pwd)

# Start nginx using the configuration file from the current directory
nginx -c "$current_dir/nginx/nginx.conf"