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
|| [Tailcall] | `21,587.90` | `4.62` | `179.99x` |
|| [GraphQL JIT] | `1,106.58` | `89.79` | `9.23x` |
|| [async-graphql] | `965.48` | `102.81` | `8.05x` |
|| [Caliban] | `756.16` | `132.38` | `6.30x` |
|| [Gqlgen] | `377.82` | `260.72` | `3.15x` |
|| [Netflix DGS] | `187.97` | `516.71` | `1.57x` |
|| [Apollo GraphQL] | `127.96` | `713.87` | `1.07x` |
|| [Hasura] | `119.94` | `782.21` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `33,391.30` | `2.99` | `71.27x` |
|| [async-graphql] | `5,082.68` | `19.68` | `10.85x` |
|| [Caliban] | `4,743.68` | `21.57` | `10.12x` |
|| [GraphQL JIT] | `1,172.22` | `85.13` | `2.50x` |
|| [Gqlgen] | `1,074.72` | `102.78` | `2.29x` |
|| [Apollo GraphQL] | `860.94` | `116.54` | `1.84x` |
|| [Netflix DGS] | `803.61` | `125.46` | `1.72x` |
|| [Hasura] | `468.54` | `223.13` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `40,619.20` | `2.47` | `24.66x` |
|| [Caliban] | `32,405.80` | `3.10` | `19.68x` |
|| [Gqlgen] | `23,629.50` | `9.69` | `14.35x` |
|| [async-graphql] | `23,274.40` | `4.32` | `14.13x` |
|| [GraphQL JIT] | `4,558.06` | `21.89` | `2.77x` |
|| [Netflix DGS] | `4,207.89` | `28.67` | `2.55x` |
|| [Apollo GraphQL] | `4,016.59` | `27.63` | `2.44x` |
|| [Hasura] | `1,647.04` | `62.57` | `1.00x` |

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
