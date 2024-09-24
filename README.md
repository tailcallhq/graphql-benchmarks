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
|| [Tailcall] | `20,353.00` | `4.84` | `177.15x` |
|| [GraphQL JIT] | `1,104.19` | `90.07` | `9.61x` |
|| [async-graphql] | `1,061.82` | `93.59` | `9.24x` |
|| [Caliban] | `862.03` | `116.76` | `7.50x` |
|| [Gqlgen] | `404.58` | `243.81` | `3.52x` |
|| [Netflix DGS] | `186.79` | `523.43` | `1.63x` |
|| [Apollo GraphQL] | `125.96` | `723.53` | `1.10x` |
|| [Hasura] | `114.89` | `666.59` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `32,675.30` | `3.01` | `78.76x` |
|| [Caliban] | `5,587.26` | `17.96` | `13.47x` |
|| [async-graphql] | `5,246.09` | `19.06` | `12.65x` |
|| [GraphQL JIT] | `1,149.88` | `86.82` | `2.77x` |
|| [Gqlgen] | `1,130.89` | `96.99` | `2.73x` |
|| [Apollo GraphQL] | `860.87` | `116.78` | `2.08x` |
|| [Netflix DGS] | `811.15` | `152.96` | `1.96x` |
|| [Hasura] | `414.85` | `240.30` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `47,542.40` | `2.04` | `30.15x` |
|| [Gqlgen] | `26,136.50` | `4.80` | `16.57x` |
|| [Tailcall] | `26,015.60` | `3.83` | `16.50x` |
|| [async-graphql] | `24,962.70` | `3.99` | `15.83x` |
|| [GraphQL JIT] | `4,434.79` | `22.50` | `2.81x` |
|| [Netflix DGS] | `4,148.77` | `28.09` | `2.63x` |
|| [Apollo GraphQL] | `3,888.28` | `29.61` | `2.47x` |
|| [Hasura] | `1,576.88` | `64.34` | `1.00x` |

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
