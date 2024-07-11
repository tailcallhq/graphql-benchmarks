#!/bin/bash

function killServerOnPort() {
    local port="$1"
    local pid=$(lsof -t -i:"$port")

    if [ -n "$pid" ]; then
        kill "$pid"
        echo "Killed process running on port $port"
    else
        echo "No process found running on port $port"
    fi
}

declare -a bench1Results=()
declare -a bench2Results=()
declare -a bench3Results=()

function runBenchmark() {
    local serviceScript="$1"
    local benchmarks=(1 2 3)
    local servicePid
    killServerOnPort 8000
    sleep 2

    if [[ "$serviceScript" == *"hasura"* ]]; then
        bash "$serviceScript" & 
    else
        bash "$serviceScript" & 
    fi
    servicePid=$!

    sleep 15 

    local graphqlEndpoint="http://localhost:8000/graphql"
    if [[ "$serviceScript" == *"hasura"* ]]; then
        graphqlEndpoint=http://$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' graphql-engine):8080/v1/graphql
    fi

    for bench in "${benchmarks[@]}"; do
        local benchmarkScript="wrk/bench.sh"
        local sanitizedServiceScriptName=$(echo "$serviceScript" | tr '/' '_')
        local resultFiles=("result1_${sanitizedServiceScriptName}.txt" "result2_${sanitizedServiceScriptName}.txt" "result3_${sanitizedServiceScriptName}.txt")

        bash "test_query${bench}.sh" "$graphqlEndpoint"

        bash "$benchmarkScript" "$graphqlEndpoint" "$bench" >/dev/null
        sleep 1 # Adjusted sleep time after warmup run
        bash "$benchmarkScript" "$graphqlEndpoint" "$bench" >/dev/null
        sleep 1
        bash "$benchmarkScript" "$graphqlEndpoint" "$bench" >/dev/null
        sleep 1

        # Execute 3 benchmark runs
        for resultFile in "${resultFiles[@]}"; do
            echo "Running benchmark $bench for $serviceScript"
            bash "$benchmarkScript" "$graphqlEndpoint" "$bench" >"bench${bench}_${resultFile}"
            case "$bench" in
            1) bench1Results+=("bench1_${resultFile}") ;;
            2) bench2Results+=("bench2_${resultFile}") ;;
            3) bench3Results+=("bench3_${resultFile}") ;;
            esac
        done
    done

    if [ "$serviceScript" == "graphql/apollo_server/run.sh" ]; then
        cd graphql/apollo_server/
        npm stop
        cd ../../
    elif [ "$serviceScript" == "graphql/hasura/run.sh" ]; then
        bash "graphql/hasura/kill.sh"
    else
        kill "$servicePid"
    fi
    wait "$servicePid"
}

rm -f "results.md"

services=("graphql/apollo_server/run.sh" "graphql/caliban/run.sh" "graphql/netflix_dgs/run.sh" "graphql/gqlgen/run.sh" "graphql/tailcall/run.sh" "graphql/async_graphql/run.sh" "graphql/hasura/run.sh" "graphql/graphql_jit/run.sh")

echo "Starting benchmarks sequentially"
for service in "${services[@]}"; do
    runBenchmark "$service"
done

echo "All benchmarks completed"

echo "Starting result analysis"
bash analyze.sh "${bench1Results[@]}"
bash analyze.sh "${bench2Results[@]}"
bash analyze.sh "${bench3Results[@]}"
echo "Result analysis completed"
