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
|| [Tailcall] | `19,228.80` | `5.19` | `175.23x` |
|| [GraphQL JIT] | `1,105.77` | `89.97` | `10.08x` |
|| [async-graphql] | `935.42` | `106.14` | `8.52x` |
|| [Caliban] | `790.39` | `126.95` | `7.20x` |
|| [Gqlgen] | `364.79` | `269.93` | `3.32x` |
|| [Netflix DGS] | `181.59` | `534.84` | `1.65x` |
|| [Apollo GraphQL] | `127.06` | `717.85` | `1.16x` |
|| [Hasura] | `109.73` | `800.75` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `30,423.10` | `3.28` | `72.65x` |
|| [async-graphql] | `5,031.10` | `20.01` | `12.01x` |
|| [Caliban] | `4,842.66` | `21.09` | `11.56x` |
|| [GraphQL JIT] | `1,161.21` | `85.96` | `2.77x` |
|| [Gqlgen] | `1,064.08` | `102.89` | `2.54x` |
|| [Apollo GraphQL] | `882.92` | `113.32` | `2.11x` |
|| [Netflix DGS] | `758.03` | `132.60` | `1.81x` |
|| [Hasura] | `418.79` | `240.99` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `38,037.30` | `2.63` | `26.83x` |
|| [Tailcall] | `23,941.30` | `4.19` | `16.89x` |
|| [async-graphql] | `23,423.90` | `4.28` | `16.52x` |
|| [Gqlgen] | `23,056.60` | `11.06` | `16.26x` |
|| [GraphQL JIT] | `4,658.06` | `21.42` | `3.29x` |
|| [Netflix DGS] | `4,097.78` | `28.88` | `2.89x` |
|| [Apollo GraphQL] | `3,999.80` | `28.21` | `2.82x` |
|| [Hasura] | `1,417.72` | `71.19` | `1.00x` |

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
