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
|| [Tailcall] | `30,559.20` | `3.26` | `112.28x` |
|| [async-graphql] | `1,920.74` | `52.01` | `7.06x` |
|| [Caliban] | `1,608.05` | `61.99` | `5.91x` |
|| [Hasura] | `1,514.93` | `65.77` | `5.57x` |
|| [GraphQL JIT] | `1,351.96` | `73.67` | `4.97x` |
|| [Gqlgen] | `777.12` | `127.66` | `2.86x` |
|| [Netflix DGS] | `361.49` | `168.42` | `1.33x` |
|| [Apollo GraphQL] | `272.16` | `360.30` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `62,523.70` | `1.59` | `44.47x` |
|| [async-graphql] | `9,521.21` | `10.52` | `6.77x` |
|| [Caliban] | `9,406.40` | `10.98` | `6.69x` |
|| [Hasura] | `2,523.10` | `39.61` | `1.79x` |
|| [Gqlgen] | `2,193.04` | `47.29` | `1.56x` |
|| [Apollo GraphQL] | `1,770.63` | `56.39` | `1.26x` |
|| [Netflix DGS] | `1,592.90` | `69.39` | `1.13x` |
|| [GraphQL JIT] | `1,406.01` | `71.02` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `68,363.30` | `1.06` | `26.45x` |
|| [Tailcall] | `64,757.00` | `1.56` | `25.06x` |
|| [async-graphql] | `51,375.20` | `2.04` | `19.88x` |
|| [Gqlgen] | `47,426.90` | `5.03` | `18.35x` |
|| [Netflix DGS] | `8,236.22` | `14.86` | `3.19x` |
|| [Apollo GraphQL] | `8,083.09` | `12.62` | `3.13x` |
|| [GraphQL JIT] | `5,195.72` | `19.22` | `2.01x` |
|| [Hasura] | `2,584.30` | `38.63` | `1.00x` |

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
