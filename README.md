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
|| [Tailcall] | `29,865.00` | `3.34` | `112.98x` |
|| [async-graphql] | `1,824.45` | `54.68` | `6.90x` |
|| [Caliban] | `1,631.74` | `60.96` | `6.17x` |
|| [Hasura] | `1,513.32` | `65.92` | `5.72x` |
|| [GraphQL JIT] | `1,308.30` | `76.09` | `4.95x` |
|| [Gqlgen] | `771.42` | `128.66` | `2.92x` |
|| [Netflix DGS] | `360.56` | `174.79` | `1.36x` |
|| [Apollo GraphQL] | `264.34` | `370.65` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `61,611.40` | `1.61` | `45.11x` |
|| [Caliban] | `9,406.21` | `10.99` | `6.89x` |
|| [async-graphql] | `9,366.90` | `10.76` | `6.86x` |
|| [Hasura] | `2,450.62` | `40.79` | `1.79x` |
|| [Gqlgen] | `2,150.47` | `48.08` | `1.57x` |
|| [Apollo GraphQL] | `1,745.86` | `57.22` | `1.28x` |
|| [Netflix DGS] | `1,602.77` | `69.19` | `1.17x` |
|| [GraphQL JIT] | `1,365.94` | `73.10` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `69,058.50` | `1.06` | `27.21x` |
|| [Tailcall] | `63,879.10` | `1.58` | `25.17x` |
|| [async-graphql] | `50,746.10` | `2.10` | `20.00x` |
|| [Gqlgen] | `46,935.70` | `5.11` | `18.50x` |
|| [Netflix DGS] | `8,233.67` | `14.43` | `3.24x` |
|| [Apollo GraphQL] | `8,028.37` | `12.66` | `3.16x` |
|| [GraphQL JIT] | `5,097.42` | `19.59` | `2.01x` |
|| [Hasura] | `2,537.66` | `39.39` | `1.00x` |

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
