graphqlEndpoint="${1:-http://localhost:8000/graphql}"
wrk -d 10 -t 4 -c 100 -s $(pwd)/wrk/wrk2.lua $graphqlEndpoint
