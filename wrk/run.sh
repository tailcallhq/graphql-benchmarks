graphqlEndpoint="${1:-http://localhost:8000/graphql}"
whichBench=$2

if [ "$whichBench" == "./wrk/benchmarks/wrk2.lua" ]; then
    wrk -d 30 -t 4 -c 100 -s "$(pwd)/${whichBench}" "$graphqlEndpoint"
else
    wrk -d 10 -t 4 -c 100 -s "$(pwd)/${whichBench}" "$graphqlEndpoint"
fi
