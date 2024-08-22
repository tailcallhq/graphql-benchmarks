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
|| [Tailcall] | `29,203.30` | `3.41` | `128.41x` |
|| [async-graphql] | `2,047.70` | `48.71` | `9.00x` |
|| [Caliban] | `1,709.17` | `58.31` | `7.52x` |
|| [GraphQL JIT] | `1,313.71` | `75.83` | `5.78x` |
|| [Gqlgen] | `747.63` | `132.69` | `3.29x` |
|| [Netflix DGS] | `366.05` | `242.58` | `1.61x` |
|| [Apollo GraphQL] | `270.66` | `362.93` | `1.19x` |
|| [Hasura] | `227.42` | `431.08` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `58,775.20` | `1.70` | `86.68x` |
|| [async-graphql] | `10,292.60` | `9.80` | `15.18x` |
|| [Caliban] | `9,698.01` | `10.65` | `14.30x` |
|| [Gqlgen] | `2,118.81` | `48.86` | `3.12x` |
|| [Apollo GraphQL] | `1,765.01` | `56.58` | `2.60x` |
|| [Netflix DGS] | `1,600.59` | `70.00` | `2.36x` |
|| [GraphQL JIT] | `1,322.71` | `75.49` | `1.95x` |
|| [Hasura] | `678.05` | `147.30` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `67,227.00` | `1.08` | `27.37x` |
|| [Tailcall] | `59,527.00` | `1.70` | `24.24x` |
|| [async-graphql] | `47,647.90` | `2.15` | `19.40x` |
|| [Gqlgen] | `45,428.30` | `5.32` | `18.50x` |
|| [Netflix DGS] | `8,279.27` | `14.72` | `3.37x` |
|| [Apollo GraphQL] | `8,122.04` | `12.50` | `3.31x` |
|| [GraphQL JIT] | `4,998.56` | `19.97` | `2.04x` |
|| [Hasura] | `2,455.98` | `40.72` | `1.00x` |

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
