#!/bin/bash

PORT=$1

oha -z 10s -c 100 -m POST \
    -H "Connection: keep-alive" \
    -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36" \
    -H "Content-Type: application/json" \
    -d '{"operationName":null,"variables":{},"query":"{posts{title}}"}' \
    --json \
    http://localhost:$PORT/graphql