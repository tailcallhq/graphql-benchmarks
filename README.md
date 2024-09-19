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
|| [Tailcall] | `19,681.30` | `5.07` | `169.21x` |
|| [GraphQL JIT] | `1,130.78` | `87.99` | `9.72x` |
|| [async-graphql] | `1,014.52` | `97.91` | `8.72x` |
|| [Caliban] | `722.26` | `138.32` | `6.21x` |
|| [Gqlgen] | `404.48` | `243.81` | `3.48x` |
|| [Netflix DGS] | `189.02` | `508.48` | `1.63x` |
|| [Apollo GraphQL] | `120.84` | `747.36` | `1.04x` |
|| [Hasura] | `116.31` | `770.11` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `31,263.60` | `3.19` | `68.85x` |
|| [async-graphql] | `5,301.58` | `18.91` | `11.68x` |
|| [Caliban] | `4,792.34` | `21.32` | `10.55x` |
|| [GraphQL JIT] | `1,165.55` | `85.63` | `2.57x` |
|| [Gqlgen] | `1,130.86` | `96.65` | `2.49x` |
|| [Apollo GraphQL] | `825.57` | `121.62` | `1.82x` |
|| [Netflix DGS] | `795.98` | `126.26` | `1.75x` |
|| [Hasura] | `454.07` | `236.80` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `37,772.60` | `2.64` | `26.69x` |
|| [Tailcall] | `24,657.80` | `4.07` | `17.42x` |
|| [Gqlgen] | `24,370.40` | `8.96` | `17.22x` |
|| [async-graphql] | `23,592.50` | `4.25` | `16.67x` |
|| [GraphQL JIT] | `4,552.81` | `21.91` | `3.22x` |
|| [Netflix DGS] | `4,152.22` | `29.25` | `2.93x` |
|| [Apollo GraphQL] | `3,935.03` | `28.47` | `2.78x` |
|| [Hasura] | `1,415.46` | `71.63` | `1.00x` |

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
