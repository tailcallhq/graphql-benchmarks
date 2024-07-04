test_name=$1
benchmark=$2

if [ "$IS_K6_CLOUD_ENABLED" == "true" ]; then
  k6 run k6/bench.js --quiet --out cloud --env TEST_NAME=$test_name --env BENCHMARK=$benchmark
else
    k6 run k6/bench.js --quiet --env TEST_NAME=$test_name --env BENCHMARK=$benchmark
fi
