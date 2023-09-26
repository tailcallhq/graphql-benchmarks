
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
| apollo | 761.363 | 134.837 |
| netflixdgs | 575.743 | 191.197 |
| gqlgen | 914.147 | 119.123 |
| tailcall | 2904.45 | 34.4233 |
<!-- PERFORMANCE_RESULTS_END -->

Below are the visualizations for latency and throughput comparisons across the frameworks:

| ![Latency Histogram](assets/latency_histogram.png) | ![Requests/sec Histogram](assets/req_sec_histogram.png) |
|:--------------------------------------------:|:------------------------------------------------:|
|                 Latency Histogram             |              Requests/sec Histogram              |


