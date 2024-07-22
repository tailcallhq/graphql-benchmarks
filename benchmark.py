import sys;
import subprocess;
import re;
import json;

benchmark_candidate = sys.argv[1];

# make this dynamics instead of hard coding here
config = {};
with open("./config.json", 'r') as config:
  config = json.load(config);

# graphql endpoint
graphql_endpoint = config["graphqlEndpoint"]["default"];
# override
if benchmark_candidate in config["graphqlEndpoint"].keys() :
  graphql_endpoint = config["graphqlEndpoint"][benchmark_candidate];

# some script constants
latency_regex = r'Latency\s*(\d+ms)';
requests_per_sec_regex = r'Requests\/sec:\s*(\d+)';


benchmark_results = {};

for benchmark in config["benchmarks"].keys():

  print("Running benchmark for candidate: ${benchmark_candidate}");
  
  ## start benchmark candidate server
  subprocess.call(f"graphql/${benchmark_candidate}/run.sh");

  ## warmup the server
  print("Running warmup for candidate: ${benchmark_candidate}");
  for i in range(1, config["warmup_reqs"] + 1):
    subprocess.call(f"bash ./wrk/run.sh ${benchmark_candidate} ${graphql_endpoint} ${config["benchmarks"][benchmark]}");
    subprocess.call("sleep 1");
  
  benchmark_result = {};
  bench = config["benchmarks"][benchmark];
  for i in range(1, config["reRuns"] + 1):
    # run benchmark script
    output = subprocess.getoutput(f"bash ./wrk/run.sh ${benchmark_candidate} ${graphql_endpoint} ${bench}");
    print(output)

    # requests per sec
    reqs_sec = None; 
    match = re.search(requests_per_sec_regex, output)
    if match :
      reqs_sec = match.group(1);
    
    # latency in ms
    latency = None;
    match = re.search(latency_regex, output);
    if match :
      latency = match.group(1)[:-2];
    
    #
    if reqs_sec and latency:
      # store results
      benchmark_result[i] = {"reqs_sec": int(reqs_sec), "latency": int(latency)};
  
  # no of benchmarks 
  no_of_benchmarks  = len(benchmark_result);

  if no_of_benchmarks>0 :
    benchmark_results[benchmark] = {
      "reqs_sec": int(sum(benchmark_result["reqs_sec"] for benchmark_result in benchmark_result.values())/no_of_benchmarks),
      "latency": sum(benchmark_result["latency"] for benchmark_result in benchmark_result.values())/no_of_benchmarks
    };

# save results to a json file
with open(f"benchmark_result_${benchmark_candidate}.json", 'w') as f:
  json.dump({benchmark_candidate + "": benchmark_results}, f);