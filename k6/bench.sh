test_name=$1
benchmark=$2

# k6 run k6/bench.js --quiet --out cloud --env TEST_NAME=$test_name --env BENCHMARK=$benchmark
k6 run k6/bench.js --quiet --env TEST_NAME=$test_name --env BENCHMARK=$benchmark
