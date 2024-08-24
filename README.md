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
|| [Tailcall] | `29,675.10` | `3.36` | `125.86x` |
|| [async-graphql] | `2,020.61` | `50.40` | `8.57x` |
|| [Caliban] | `1,682.82` | `59.16` | `7.14x` |
|| [GraphQL JIT] | `1,350.14` | `73.75` | `5.73x` |
|| [Gqlgen] | `773.85` | `128.23` | `3.28x` |
|| [Netflix DGS] | `360.30` | `183.27` | `1.53x` |
|| [Apollo GraphQL] | `260.68` | `376.91` | `1.11x` |
|| [Hasura] | `235.77` | `414.86` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `58,905.90` | `1.69` | `86.66x` |
|| [async-graphql] | `10,370.00` | `9.70` | `15.26x` |
|| [Caliban] | `9,660.87` | `10.69` | `14.21x` |
|| [Gqlgen] | `2,151.88` | `48.11` | `3.17x` |
|| [Apollo GraphQL] | `1,736.24` | `57.54` | `2.55x` |
|| [Netflix DGS] | `1,584.15` | `71.31` | `2.33x` |
|| [GraphQL JIT] | `1,375.76` | `72.59` | `2.02x` |
|| [Hasura] | `679.76` | `146.93` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `68,809.20` | `1.05` | `28.43x` |
|| [Tailcall] | `58,802.80` | `1.71` | `24.30x` |
|| [async-graphql] | `48,579.00` | `2.11` | `20.07x` |
|| [Gqlgen] | `47,473.00` | `4.96` | `19.62x` |
|| [Netflix DGS] | `8,138.61` | `14.85` | `3.36x` |
|| [Apollo GraphQL] | `7,937.89` | `12.72` | `3.28x` |
|| [GraphQL JIT] | `5,212.71` | `19.15` | `2.15x` |
|| [Hasura] | `2,420.18` | `41.48` | `1.00x` |

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
