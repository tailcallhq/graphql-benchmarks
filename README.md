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
|| [Tailcall] | `30,093.30` | `3.31` | `129.80x` |
|| [async-graphql] | `2,014.37` | `50.26` | `8.69x` |
|| [Caliban] | `1,778.47` | `55.99` | `7.67x` |
|| [GraphQL JIT] | `1,204.15` | `82.65` | `5.19x` |
|| [Gqlgen] | `772.64` | `128.47` | `3.33x` |
|| [Netflix DGS] | `365.38` | `165.74` | `1.58x` |
|| [Apollo GraphQL] | `264.96` | `371.13` | `1.14x` |
|| [Hasura] | `231.85` | `427.34` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `59,479.40` | `1.67` | `82.86x` |
|| [async-graphql] | `10,280.90` | `9.93` | `14.32x` |
|| [Caliban] | `10,240.40` | `10.08` | `14.26x` |
|| [Gqlgen] | `2,153.27` | `48.16` | `3.00x` |
|| [Apollo GraphQL] | `1,760.01` | `56.73` | `2.45x` |
|| [Netflix DGS] | `1,581.18` | `70.97` | `2.20x` |
|| [GraphQL JIT] | `1,249.92` | `79.88` | `1.74x` |
|| [Hasura] | `717.87` | `139.57` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `68,933.80` | `1.02` | `27.15x` |
|| [Tailcall] | `60,467.80` | `1.67` | `23.81x` |
|| [async-graphql] | `47,120.80` | `2.36` | `18.56x` |
|| [Gqlgen] | `46,378.50` | `5.12` | `18.26x` |
|| [Netflix DGS] | `8,127.12` | `14.62` | `3.20x` |
|| [Apollo GraphQL] | `8,096.73` | `12.54` | `3.19x` |
|| [GraphQL JIT] | `4,981.39` | `20.04` | `1.96x` |
|| [Hasura] | `2,539.24` | `39.38` | `1.00x` |

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
