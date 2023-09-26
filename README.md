# GraphQL Frameworks Benchmark

This document presents a comparative analysis of several renowned GraphQL frameworks:

- [**Tailcall**](https://tailcall.run/)
- [**Gqlgen**](https://gqlgen.com/)
- [**Apollo Server**](https://new.apollographql.com/)
- [**Netflix DGS**](https://netflix.github.io/dgs/)

## Setting Up the Benchmark

You can effortlessly set up your benchmarking environment with a single click:

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/tailcallhq/graphql-benchmarks)

## Execution

After completing the setup in Codespaces, you can start the benchmark tests by running:

```bash
./run_benchmarks.sh
```

## Benchmark Results
<!-- PERFORMANCE_RESULTS_START -->
| Server       | Requests/sec | Latency (ms) |
|--------------|--------------:|--------------:|
| Tailcall     | `2,890.68`   | `34.69`      |
| Gqlgen       | `935.00`     | `115.73`     |
| Apollo       | `793.37`     | `128.22`     |
| Netflix DGS  | `597.39`     | `191.85`     |

<!-- PERFORMANCE_RESULTS_END -->

## Throughput (Higher is better)

![Throughput Histogram](assets/req_sec_histogram.png)

## Latency (Lower is better)

![Latency Histogram](assets/latency_histogram.png)

## Architecture
![Architecture Diagram](assets/architecture.png)