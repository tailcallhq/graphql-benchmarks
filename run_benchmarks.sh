#!/bin/bash

# Start services and run benchmarks
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
allResults=()
killServerOnPort 3000
sh nginx/run.sh

function runBenchmark() {
	killServerOnPort 8000
	sleep 5
	local serviceScript="$1"
	local runDaemon="${2:-true}"
	local benchmarkScript="wrk/bench.sh"

	# Replace / with _
	local sanitizedServiceScriptName=$(echo "$serviceScript" | tr '/' '_')

	local resultFiles=("result1_${sanitizedServiceScriptName}.txt" "result2_${sanitizedServiceScriptName}.txt" "result3_${sanitizedServiceScriptName}.txt")

	if [ "$runDaemon" = true ]; then
		bash "$serviceScript" & # Run in daemon mode
	else
		bash "$serviceScript" # Run synchronously without background process
	fi

	sleep 15 # Give some time for the service to start up

	local graphqlEndpoint="http://localhost:8000/graphql"
	if [[ "$serviceScript" == *"hasura"* ]]; then
		graphqlEndpoint=http://$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' graphql-engine):8080/v1/graphql
	fi

	bash "test_query.sh" "$graphqlEndpoint"

	# Warmup run
	bash "$benchmarkScript" "$graphqlEndpoint" >/dev/null
	sleep 1 # Give some time for apps to finish in-flight requests from warmup
	bash "$benchmarkScript" "$graphqlEndpoint" >/dev/null
	sleep 1
	bash "$benchmarkScript" "$graphqlEndpoint" >/dev/null
	sleep 1

	# 3 benchmark runs
	for resultFile in "${resultFiles[@]}"; do
		bash "$benchmarkScript" "$graphqlEndpoint" >"$resultFile"
		allResults+=("$resultFile")
	done
}

runBenchmark "graphql/apollo_server/run.sh"
cd graphql/apollo_server/
npm stop
cd ../../

runBenchmark "graphql/caliban/run.sh"

runBenchmark "graphql/netflix_dgs/run.sh"

runBenchmark "graphql/gqlgen/run.sh"

runBenchmark "graphql/tailcall/run.sh"

runBenchmark "graphql/async_graphql/run.sh"

runBenchmark "graphql/hasura/run.sh" false
bash "graphql/hasura/kill.sh"

# Now, analyze all results together
bash analyze.sh "${allResults[@]}"
