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
|| [Tailcall] | `20,630.50` | `4.83` | `177.46x` |
|| [GraphQL JIT] | `1,068.27` | `93.07` | `9.19x` |
|| [async-graphql] | `954.88` | `104.21` | `8.21x` |
|| [Caliban] | `770.27` | `129.84` | `6.63x` |
|| [Gqlgen] | `397.69` | `247.87` | `3.42x` |
|| [Netflix DGS] | `184.67` | `521.67` | `1.59x` |
|| [Apollo GraphQL] | `130.17` | `703.65` | `1.12x` |
|| [Hasura] | `116.26` | `782.10` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `29,799.40` | `3.36` | `66.57x` |
|| [async-graphql] | `4,792.76` | `20.88` | `10.71x` |
|| [Caliban] | `4,744.60` | `21.59` | `10.60x` |
|| [Gqlgen] | `1,115.36` | `97.85` | `2.49x` |
|| [GraphQL JIT] | `1,107.40` | `90.11` | `2.47x` |
|| [Apollo GraphQL] | `869.73` | `115.46` | `1.94x` |
|| [Netflix DGS] | `791.66` | `126.88` | `1.77x` |
|| [Hasura] | `447.61` | `230.98` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `38,376.50` | `2.61` | `25.61x` |
|| [Caliban] | `32,962.50` | `3.03` | `21.99x` |
|| [Gqlgen] | `24,449.20` | `9.34` | `16.31x` |
|| [async-graphql] | `23,320.30` | `4.31` | `15.56x` |
|| [GraphQL JIT] | `4,497.61` | `22.19` | `3.00x` |
|| [Netflix DGS] | `4,171.11` | `28.47` | `2.78x` |
|| [Apollo GraphQL] | `3,959.57` | `28.19` | `2.64x` |
|| [Hasura] | `1,498.67` | `67.60` | `1.00x` |

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
