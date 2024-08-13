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
|| [Tailcall] | `27,672.40` | `3.60` | `267.66x` |
|| [async-graphql] | `2,024.84` | `49.66` | `19.59x` |
|| [Caliban] | `1,701.60` | `58.53` | `16.46x` |
|| [GraphQL JIT] | `1,301.74` | `76.45` | `12.59x` |
|| [Gqlgen] | `800.38` | `124.00` | `7.74x` |
|| [Netflix DGS] | `361.99` | `233.97` | `3.50x` |
|| [Apollo GraphQL] | `270.66` | `362.76` | `2.62x` |
|| [Hasura] | `103.39` | `552.64` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `56,964.10` | `1.75` | `67.40x` |
|| [async-graphql] | `10,285.40` | `9.81` | `12.17x` |
|| [Caliban] | `9,895.00` | `10.42` | `11.71x` |
|| [Gqlgen] | `2,163.17` | `47.92` | `2.56x` |
|| [Apollo GraphQL] | `1,759.04` | `56.79` | `2.08x` |
|| [Netflix DGS] | `1,583.59` | `70.85` | `1.87x` |
|| [GraphQL JIT] | `1,355.75` | `73.68` | `1.60x` |
|| [Hasura] | `845.22` | `118.04` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `68,740.70` | `1.05` | `26.39x` |
|| [Tailcall] | `58,084.50` | `1.74` | `22.30x` |
|| [async-graphql] | `48,294.00` | `2.22` | `18.54x` |
|| [Gqlgen] | `46,520.30` | `5.58` | `17.86x` |
|| [Netflix DGS] | `8,163.83` | `15.00` | `3.13x` |
|| [Apollo GraphQL] | `8,048.30` | `12.62` | `3.09x` |
|| [GraphQL JIT] | `5,082.40` | `19.65` | `1.95x` |
|| [Hasura] | `2,604.49` | `38.31` | `1.00x` |

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
