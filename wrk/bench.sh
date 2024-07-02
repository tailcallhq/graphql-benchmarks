whichBench=$1

if [ "$whichBench" == "2" ]; then
    wrk -d 30 -t 4 -c 100 -s $(pwd)/wrk/wrk2.lua http://localhost:8000/graphql
else
    wrk -d 10 -t 4 -c 100 -s "$(pwd)/wrk/wrk${whichBench}.lua" http://localhost:8000/graphql
fi
