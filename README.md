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
|| [Tailcall] | `29,677.50` | `3.36` | `134.75x` |
|| [async-graphql] | `1,934.92` | `51.87` | `8.79x` |
|| [Caliban] | `1,743.44` | `57.54` | `7.92x` |
|| [GraphQL JIT] | `1,301.37` | `76.49` | `5.91x` |
|| [Gqlgen] | `795.73` | `124.70` | `3.61x` |
|| [Netflix DGS] | `366.48` | `207.06` | `1.66x` |
|| [Apollo GraphQL] | `272.12` | `361.25` | `1.24x` |
|| [Hasura] | `220.24` | `453.36` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `58,969.10` | `1.68` | `84.24x` |
|| [async-graphql] | `10,118.70` | `10.03` | `14.46x` |
|| [Caliban] | `9,983.51` | `10.34` | `14.26x` |
|| [Gqlgen] | `2,157.90` | `47.95` | `3.08x` |
|| [Apollo GraphQL] | `1,777.03` | `56.22` | `2.54x` |
|| [Netflix DGS] | `1,606.62` | `69.91` | `2.30x` |
|| [GraphQL JIT] | `1,315.55` | `75.91` | `1.88x` |
|| [Hasura] | `699.99` | `143.16` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `68,870.80` | `1.03` | `27.55x` |
|| [Tailcall] | `59,336.90` | `1.70` | `23.74x` |
|| [async-graphql] | `47,704.00` | `2.16` | `19.08x` |
|| [Gqlgen] | `47,643.10` | `5.24` | `19.06x` |
|| [Netflix DGS] | `8,216.10` | `14.60` | `3.29x` |
|| [Apollo GraphQL] | `8,062.57` | `12.72` | `3.23x` |
|| [GraphQL JIT] | `5,041.13` | `19.81` | `2.02x` |
|| [Hasura] | `2,499.57` | `40.13` | `1.00x` |

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
