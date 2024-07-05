graphqlEndpoint="${1:-http://localhost:8000/graphql}"
whichBench=$2

if [ "$whichBench" == "2" ]; then
    wrk -d 30 -t 4 -c 100 -s $(pwd)/wrk/wrk2.lua "$graphqlEndpoint"
else
    wrk -d 10 -t 4 -c 100 -s "$(pwd)/wrk/wrk${whichBench}.lua" "$graphqlEndpoint"
fi
