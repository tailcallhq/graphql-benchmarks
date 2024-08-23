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
|| [Tailcall] | `27,295.80` | `3.65` | `116.25x` |
|| [async-graphql] | `2,076.62` | `48.37` | `8.84x` |
|| [Caliban] | `1,785.74` | `55.80` | `7.61x` |
|| [GraphQL JIT] | `1,361.91` | `73.13` | `5.80x` |
|| [Gqlgen] | `807.80` | `122.88` | `3.44x` |
|| [Netflix DGS] | `366.14` | `201.22` | `1.56x` |
|| [Apollo GraphQL] | `270.18` | `363.32` | `1.15x` |
|| [Hasura] | `234.80` | `420.54` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `56,459.70` | `1.76` | `82.63x` |
|| [async-graphql] | `10,244.50` | `9.87` | `14.99x` |
|| [Caliban] | `9,870.35` | `10.47` | `14.44x` |
|| [Gqlgen] | `2,224.19` | `46.65` | `3.25x` |
|| [Apollo GraphQL] | `1,785.68` | `55.92` | `2.61x` |
|| [Netflix DGS] | `1,615.43` | `69.41` | `2.36x` |
|| [GraphQL JIT] | `1,398.84` | `71.38` | `2.05x` |
|| [Hasura] | `683.32` | `146.98` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `68,279.40` | `1.08` | `27.44x` |
|| [Tailcall] | `58,161.50` | `1.74` | `23.38x` |
|| [async-graphql] | `48,288.60` | `2.16` | `19.41x` |
|| [Gqlgen] | `47,985.30` | `4.98` | `19.29x` |
|| [Netflix DGS] | `8,316.58` | `14.29` | `3.34x` |
|| [Apollo GraphQL] | `8,172.42` | `12.40` | `3.28x` |
|| [GraphQL JIT] | `5,228.60` | `19.10` | `2.10x` |
|| [Hasura] | `2,488.11` | `40.22` | `1.00x` |

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
