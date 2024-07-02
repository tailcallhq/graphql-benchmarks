#!/bin/bash

DURATION="10s"
QUERY='{"operationName":null,"variables":{},"query":"{posts{title}}"}'

oha -z $DURATION -c 100 -m POST \
    -H "Connection: keep-alive" \
    -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36" \
    -H "Content-Type: application/json" \
    -d "$QUERY" \
    http://localhost:8000/graphql
