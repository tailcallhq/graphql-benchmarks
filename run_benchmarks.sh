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
bench1Results=()
bench2Results=()
bench3Results=()
killServerOnPort 3000
sh nginx/run.sh

function runBenchmark() {
    killServerOnPort 8000
    sleep 5
    local service="$1"
    local serviceScript="graphql/${service}/run.sh"
    local benchmarks=(1 2 3)

  if [[ "$service" == "hasura" ]]; then
    bash "$serviceScript" # Run synchronously without background process
  else
    bash "$serviceScript" & # Run in daemon mode
  fi

  sleep 15 # Give some time for the service to start up

  local graphqlEndpoint="http://localhost:8000/graphql"
  if [[ "$service" == "hasura" ]]; then
    graphqlEndpoint=http://$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' graphql-engine):8080/v1/graphql
  fi

  for bench in "${benchmarks[@]}"; do
    local benchmarkScript="wrk/bench.sh"

    # Replace / with _
    local sanitizedServiceScriptName=$(echo "$serviceScript" | tr '/' '_')

    local resultFiles=("result1_${sanitizedServiceScriptName}.txt" "result2_${sanitizedServiceScriptName}.txt" "result3_${sanitizedServiceScriptName}.txt")

    bash "test_query${bench}.sh" "$graphqlEndpoint"

    # Warmup run
    bash "$benchmarkScript" "$graphqlEndpoint" "$bench" >/dev/null
    sleep 1 # Give some time for apps to finish in-flight requests from warmup
    bash "$benchmarkScript" "$graphqlEndpoint" "$bench" >/dev/null
    sleep 1
    bash "$benchmarkScript" "$graphqlEndpoint" "$bench" >/dev/null
    sleep 1

        # 3 benchmark runs
        for resultFile in "${resultFiles[@]}"; do
            echo "Running benchmark $bench for $serviceScript"
            bash "$benchmarkScript" "$graphqlEndpoint" "$service" "$bench" > "bench${bench}_${resultFile}"
            if [ "$bench" == "1" ]; then
                bench1Results+=("bench1_${resultFile}")
            elif [ "$bench" == "2" ]; then
                bench2Results+=("bench2_${resultFile}")
            elif [ "$bench" == "3" ]; then
                bench3Results+=("bench3_${resultFile}")
            fi
        done
    done
}

rm "results.md"

for service in "apollo_server" "caliban" "netflix_dgs" "gqlgen" "tailcall" "async_graphql" "hasura" "graphql_jit"; do
  runBenchmark "$service"
  if [ "$service" == "apollo_server" ]; then
    cd graphql/apollo_server/
    npm stop
    cd ../../
  elif [ "$service" == "hasura" ]; then
    bash "graphql/hasura/kill.sh"
  fi
done

bash analyze.sh "${bench1Results[@]}"
bash analyze.sh "${bench2Results[@]}"
bash analyze.sh "${bench3Results[@]}"

if [[ "$UPLOAD_TO_CLOUD" == "true" ]]; then
  # Wait for 5 seconds to ensure the results are uploaded to influxdb
  sleep 5

  # Get rendered panels from grafana
  from=$(date -u -d "-30 minutes" +"%Y-%m-%dT%H:%M:%S.%3NZ")
  now=$(date -u +"%Y-%m-%dT%H:%M:%S.%3NZ")
  curl -o assets/posts_users_req.png -H "Authorization: Bearer $GRAFANA_API_KEY" "https://tailcall.grafana.net/render/d-solo/cdqucydulbfggb?tab=queries&from=$from&to=$now&panelId=panel-1&__feature.dashboardSceneSolo&width=1000&height=500&tz=Asia%2FCalcutta" --connect-timeout 120
  curl -o assets/posts_users_latency.png -H "Authorization: Bearer $GRAFANA_API_KEY" "https://tailcall.grafana.net/render/d-solo/cdqucydulbfggb?tab=queries&from=$from&to=$now&panelId=panel-2&__feature.dashboardSceneSolo&width=1000&height=500&tz=Asia%2FCalcutta" --connect-timeout 120
  curl -o assets/posts_req.png -H "Authorization: Bearer $GRAFANA_API_KEY" "https://tailcall.grafana.net/render/d-solo/cdqucydulbfggb?tab=queries&from=$from&to=$now&panelId=panel-5&__feature.dashboardSceneSolo&width=1000&height=500&tz=Asia%2FCalcutta" --connect-timeout 120
  curl -o assets/posts_latency.png -H "Authorization: Bearer $GRAFANA_API_KEY" "https://tailcall.grafana.net/render/d-solo/cdqucydulbfggb?tab=queries&from=$from&to=$now&panelId=panel-6&__feature.dashboardSceneSolo&width=1000&height=500&tz=Asia%2FCalcutta" --connect-timeout 120
  curl -o assets/greet_req.png -H "Authorization: Bearer $GRAFANA_API_KEY" "https://tailcall.grafana.net/render/d-solo/cdqucydulbfggb?tab=queries&from=$from&to=$now&panelId=panel-8&__feature.dashboardSceneSolo&width=1000&height=500&tz=Asia%2FCalcutta" --connect-timeout 120
  curl -o assets/greet_latency.png -H "Authorization: Bearer $GRAFANA_API_KEY" "https://tailcall.grafana.net/render/d-solo/cdqucydulbfggb?tab=queries&from=$from&to=$now&panelId=panel-9&__feature.dashboardSceneSolo&width=1000&height=500&tz=Asia%2FCalcutta" --connect-timeout 120
fi
