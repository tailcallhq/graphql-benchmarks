graphql_endpoint=$1
type=$2
test_name=$3
benchmark=$4

if [ "$IS_K6_CLOUD_ENABLED" == "true" ] && [ "$type" == "upload" ]; then
  k6 run k6/bench.js --quiet --out cloud --env TEST_NAME=$test_name --env BENCHMARK=$benchmark --env GRAPHQL_ENDPOINT=$graphql_endpoint
else
  k6 run k6/bench.js --quiet --env TEST_NAME=$test_name --env BENCHMARK=$benchmark --env GRAPHQL_ENDPOINT=$graphql_endpoint
fi
