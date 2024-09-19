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
|| [Tailcall] | `19,985.40` | `4.99` | `164.11x` |
|| [GraphQL JIT] | `1,134.17` | `87.64` | `9.31x` |
|| [async-graphql] | `998.12` | `99.53` | `8.20x` |
|| [Caliban] | `763.79` | `130.75` | `6.27x` |
|| [Gqlgen] | `395.61` | `249.08` | `3.25x` |
|| [Netflix DGS] | `190.18` | `505.45` | `1.56x` |
|| [Apollo GraphQL] | `134.85` | `683.25` | `1.11x` |
|| [Hasura] | `121.78` | `754.70` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `31,609.20` | `3.16` | `73.96x` |
|| [async-graphql] | `5,048.31` | `19.84` | `11.81x` |
|| [Caliban] | `4,745.39` | `21.51` | `11.10x` |
|| [GraphQL JIT] | `1,174.23` | `85.00` | `2.75x` |
|| [Gqlgen] | `1,096.65` | `99.80` | `2.57x` |
|| [Apollo GraphQL] | `913.94` | `109.82` | `2.14x` |
|| [Netflix DGS] | `799.45` | `125.24` | `1.87x` |
|| [Hasura] | `427.40` | `233.58` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `37,976.50` | `2.63` | `24.04x` |
|| [Tailcall] | `24,148.60` | `4.14` | `15.28x` |
|| [Gqlgen] | `24,098.10` | `9.24` | `15.25x` |
|| [async-graphql] | `23,769.60` | `4.23` | `15.04x` |
|| [GraphQL JIT] | `4,595.69` | `21.71` | `2.91x` |
|| [Netflix DGS] | `4,188.72` | `28.51` | `2.65x` |
|| [Apollo GraphQL] | `4,094.41` | `26.43` | `2.59x` |
|| [Hasura] | `1,580.01` | `63.94` | `1.00x` |

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
