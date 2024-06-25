wrk -d 30 -t 4 -c 100 -s $(pwd)/wrk/wrk2.lua http://localhost:8000/graphql
