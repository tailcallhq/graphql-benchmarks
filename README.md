
# GraphQL Frameworks Benchmark

A comparative analysis of several popular GraphQL frameworks:

- **Tailcall** - [GitHub](https://github.com/tailcallhq/tailcall)
- **gqlgen** - [GitHub](https://github.com/99designs/gqlgen)
- **Apollo Server** - [Official Docs](https://www.apollographql.com/docs/apollo-server/)
- **Netflix DGS** - [Official Docs](https://netflix.github.io/dgs/)
---
## Setting up the Benchmark

Kickstart your benchmarking environment with just one click:

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/tailcallhq/graphql-benchmarks)

---

## Execution

Once the post-creation setup in Codespaces is complete, initiate the benchmark tests using:

```bash
./run_benchmarks.sh
```

## Benchmark Results
<!-- PERFORMANCE_RESULTS_START -->
| Server | Requests/sec | Latency (ms) |
|--------|--------------|--------------|
| apollo | 775.3 | 132.24 |
| netflixdgs | 497.43 | 213.723 |
| gqlgen | 914.94 | 118.85 |
| tailcall | 2888.45 | 34.7867 |
<!-- PERFORMANCE_RESULTS_END -->

| Server | Requests/sec | Latency (ms) |
|--------|--------------|--------------|
| apollo | 774.227 | 132.44 |
| netflixdgs | -nan | -nan |
| gqlgen | 964.177 | 112.787 |
| tailcall | 2820.57 | 35.61 |
<!-- PERFORMANCE_RESULTS_END -->

Below are the visualizations for latency and throughput comparisons across the frameworks:

| ![Latency Histogram](assets/latency_histogram.png) | ![Requests/sec Histogram](assets/req_sec_histogram.png) |
|:--------------------------------------------:|:------------------------------------------------:|
|                 Latency Histogram             |              Requests/sec Histogram              |


