graphql_endpoint=$1
test_name=$2
benchmark=$3

k6 run k6/bench.js --env TEST_NAME=$test_name --env BENCHMARK=$benchmark --env GRAPHQL_ENDPOINT=$graphql_endpoint --quiet
