# GraphQL Benchmarks <!-- omit from toc -->

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/tailcallhq/graphql-benchmarks)

Explore and compare the performance of the fastest GraphQL frameworks through our comprehensive benchmarks.

- [Introduction](#introduction)
- [Quick Start](#quick-start)
- [Benchmark Results](#benchmark-results)
  - [Throughput (Higher is better)](#throughput-higher-is-better)
  - [Latency (Lower is better)](#latency-lower-is-better)
- [Architecture](#architecture)
  - [WRK](#wrk)
  - [GraphQL](#graphql)
  - [Nginx](#nginx)
  - [Jsonplaceholder](#jsonplaceholder)
- [GraphQL Schema](#graphql-schema)
- [Contribute](#contribute)

[Tailcall]: https://github.com/tailcallhq/tailcall
[Gqlgen]: https://github.com/99designs/gqlgen
[Apollo GraphQL]: https://github.com/apollographql/apollo-server
[Netflix DGS]: https://github.com/netflix/dgs-framework
[Caliban]: https://github.com/ghostdogpr/caliban
[async-graphql]: https://github.com/async-graphql/async-graphql
[Hasura]: https://github.com/hasura/graphql-engine
[GraphQL JIT]: https://github.com/zalando-incubator/graphql-jit

## Introduction

This document presents a comparative analysis of several renowned GraphQL frameworks. Dive deep into the performance metrics, and get insights into their throughput and latency.

> **NOTE:** This is a work in progress suite of benchmarks, and we would appreciate help from the community to add more frameworks or tune the existing ones for better performance.

## Quick Start

Get started with the benchmarks:

1. Click on this [link](https://codespaces.new/tailcallhq/graphql-benchmarks) to set up on GitHub Codespaces.
2. Once set up in Codespaces, initiate the benchmark tests:

```bash
./setup.sh
./run_benchmarks.sh
```

## Benchmark Results

<!-- PERFORMANCE_RESULTS_START -->

| Query | Server | Requests/sec | Latency (ms) | Relative |
|-------:|--------:|--------------:|--------------:|---------:|
| 1 | `{ posts { id userId title user { id name email }}}` |
|| [Tailcall] | `20,044.80` | `4.98` | `175.91x` |
|| [GraphQL JIT] | `1,080.03` | `92.09` | `9.48x` |
|| [async-graphql] | `889.90` | `111.51` | `7.81x` |
|| [Caliban] | `781.34` | `127.87` | `6.86x` |
|| [Gqlgen] | `394.68` | `249.89` | `3.46x` |
|| [Netflix DGS] | `188.58` | `512.74` | `1.65x` |
|| [Apollo GraphQL] | `132.83` | `692.03` | `1.17x` |
|| [Hasura] | `113.95` | `784.14` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `30,459.10` | `3.28` | `65.94x` |
|| [async-graphql] | `4,849.68` | `20.64` | `10.50x` |
|| [Caliban] | `4,833.08` | `21.26` | `10.46x` |
|| [Gqlgen] | `1,120.72` | `97.70` | `2.43x` |
|| [GraphQL JIT] | `1,113.88` | `89.60` | `2.41x` |
|| [Apollo GraphQL] | `904.14` | `110.99` | `1.96x` |
|| [Netflix DGS] | `809.67` | `123.91` | `1.75x` |
|| [Hasura] | `461.93` | `219.15` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `37,472.70` | `2.68` | `24.44x` |
|| [Caliban] | `33,326.20` | `2.99` | `21.74x` |
|| [Gqlgen] | `24,091.20` | `8.74` | `15.71x` |
|| [async-graphql] | `23,170.00` | `4.33` | `15.11x` |
|| [GraphQL JIT] | `4,475.19` | `22.28` | `2.92x` |
|| [Netflix DGS] | `4,182.63` | `28.20` | `2.73x` |
|| [Apollo GraphQL] | `4,102.58` | `27.37` | `2.68x` |
|| [Hasura] | `1,533.13` | `65.56` | `1.00x` |

<!-- PERFORMANCE_RESULTS_END -->



### 1. `{posts {title body user {name}}}`
#### Throughput (Higher is better)

![Throughput Histogram](assets/req_sec_histogram1.png)

#### Latency (Lower is better)

![Latency Histogram](assets/latency_histogram1.png)

### 2. `{posts {title body}}`
#### Throughput (Higher is better)

![Throughput Histogram](assets/req_sec_histogram2.png)

#### Latency (Lower is better)

![Latency Histogram](assets/latency_histogram2.png)

### 3. `{greet}`
#### Throughput (Higher is better)

![Throughput Histogram](assets/req_sec_histogram3.png)

#### Latency (Lower is better)

![Latency Histogram](assets/latency_histogram3.png)

## Architecture

![Architecture Diagram](assets/architecture.png)

A client (`wrk`) sends requests to a GraphQL server to fetch post titles. The GraphQL server, in turn, retrieves data from an external source, `jsonplaceholder.typicode.com`, routed through the `nginx` reverse proxy.

### WRK

`wrk` serves as our test client, sending GraphQL requests at a high rate.

### GraphQL

Our tested GraphQL server. We evaluated various implementations, ensuring no caching on the GraphQL server side.

### Nginx

A reverse-proxy that caches every response, mitigating rate-limiting and reducing network uncertainties.

### Jsonplaceholder

The primary upstream service forming the base for our GraphQL API. We query its `/posts` API via the GraphQL server.

## GraphQL Schema

Inspect the generated GraphQL schema employed for the benchmarks:

```graphql
schema {
  query: Query
}

type Query {
  posts: [Post]
}

type Post {
  id: Int!
  userId: Int!
  title: String!
  body: String!
  user: User
}

type User {
  id: Int!
  name: String!
  username: String!
  email: String!
  phone: String
  website: String
}
```

## Contribute

Your insights are invaluable! Test these benchmarks, share feedback, or contribute by adding more GraphQL frameworks or refining existing ones. Open an issue or a pull request, and let's build a robust benchmarking resource together!
