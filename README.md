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
|| [Tailcall] | `21,817.90` | `4.58` | `182.09x` |
|| [GraphQL JIT] | `1,158.13` | `85.87` | `9.67x` |
|| [async-graphql] | `980.21` | `101.32` | `8.18x` |
|| [Caliban] | `763.29` | `130.95` | `6.37x` |
|| [Gqlgen] | `400.88` | `245.87` | `3.35x` |
|| [Netflix DGS] | `188.44` | `513.10` | `1.57x` |
|| [Apollo GraphQL] | `125.87` | `725.32` | `1.05x` |
|| [Hasura] | `119.82` | `747.47` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `32,605.10` | `3.07` | `70.62x` |
|| [async-graphql] | `5,151.26` | `19.43` | `11.16x` |
|| [Caliban] | `4,874.29` | `21.02` | `10.56x` |
|| [GraphQL JIT] | `1,199.26` | `83.21` | `2.60x` |
|| [Gqlgen] | `1,139.80` | `95.88` | `2.47x` |
|| [Apollo GraphQL] | `846.61` | `118.57` | `1.83x` |
|| [Netflix DGS] | `797.20` | `125.84` | `1.73x` |
|| [Hasura] | `461.67` | `218.23` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `39,592.10` | `2.52` | `25.44x` |
|| [Caliban] | `33,401.20` | `3.00` | `21.46x` |
|| [Gqlgen] | `24,676.90` | `9.36` | `15.85x` |
|| [async-graphql] | `23,740.40` | `4.23` | `15.25x` |
|| [GraphQL JIT] | `4,731.75` | `21.09` | `3.04x` |
|| [Netflix DGS] | `4,142.65` | `28.77` | `2.66x` |
|| [Apollo GraphQL] | `3,891.32` | `27.62` | `2.50x` |
|| [Hasura] | `1,556.42` | `64.23` | `1.00x` |

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
