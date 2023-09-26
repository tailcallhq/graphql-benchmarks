wrk -d 30 -t 4 -c 100 -s $(pwd)/wrk/wrk.lua http://localhost:8081/graphql
