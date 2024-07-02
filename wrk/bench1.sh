wrk -d 10 -t 4 -c 100 -s $(pwd)/wrk/wrk1.lua http://localhost:8000/graphql
