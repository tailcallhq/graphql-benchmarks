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
|| [Tailcall] | `8,315.42` | `12.01` | `68.79x` |
|| [GraphQL JIT] | `1,135.61` | `87.58` | `9.39x` |
|| [async-graphql] | `1,012.36` | `97.98` | `8.37x` |
|| [Caliban] | `797.22` | `125.45` | `6.60x` |
|| [Gqlgen] | `399.49` | `246.90` | `3.30x` |
|| [Netflix DGS] | `188.44` | `516.66` | `1.56x` |
|| [Apollo GraphQL] | `134.35` | `686.29` | `1.11x` |
|| [Hasura] | `120.88` | `744.90` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `16,020.90` | `6.24` | `35.93x` |
|| [async-graphql] | `5,151.89` | `19.47` | `11.55x` |
|| [Caliban] | `4,841.03` | `21.16` | `10.86x` |
|| [GraphQL JIT] | `1,170.70` | `85.25` | `2.63x` |
|| [Gqlgen] | `1,134.38` | `96.28` | `2.54x` |
|| [Apollo GraphQL] | `905.19` | `110.90` | `2.03x` |
|| [Netflix DGS] | `798.87` | `125.98` | `1.79x` |
|| [Hasura] | `445.92` | `238.62` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `33,297.80` | `3.01` | `21.27x` |
|| [Gqlgen] | `24,385.00` | `8.44` | `15.58x` |
|| [async-graphql] | `23,418.30` | `4.29` | `14.96x` |
|| [Tailcall] | `20,947.50` | `4.80` | `13.38x` |
|| [GraphQL JIT] | `4,619.72` | `21.60` | `2.95x` |
|| [Netflix DGS] | `4,155.55` | `28.69` | `2.65x` |
|| [Apollo GraphQL] | `4,040.93` | `27.93` | `2.58x` |
|| [Hasura] | `1,565.46` | `65.76` | `1.00x` |

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
