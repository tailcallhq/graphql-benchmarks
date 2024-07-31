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
|| [Tailcall] | `29,651.50` | `3.36` | `235.01x` |
|| [async-graphql] | `1,999.10` | `50.30` | `15.84x` |
|| [Caliban] | `1,650.96` | `60.29` | `13.08x` |
|| [GraphQL JIT] | `1,304.11` | `76.34` | `10.34x` |
|| [Gqlgen] | `782.17` | `126.83` | `6.20x` |
|| [Netflix DGS] | `364.19` | `191.35` | `2.89x` |
|| [Apollo GraphQL] | `261.36` | `375.88` | `2.07x` |
|| [Hasura] | `126.17` | `627.44` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `59,138.20` | `1.68` | `69.65x` |
|| [async-graphql] | `9,868.30` | `10.25` | `11.62x` |
|| [Caliban] | `9,629.72` | `10.73` | `11.34x` |
|| [Gqlgen] | `2,227.38` | `46.44` | `2.62x` |
|| [Apollo GraphQL] | `1,691.21` | `59.03` | `1.99x` |
|| [Netflix DGS] | `1,596.52` | `70.33` | `1.88x` |
|| [GraphQL JIT] | `1,346.61` | `74.16` | `1.59x` |
|| [Hasura] | `849.04` | `117.56` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `69,932.10` | `0.99` | `28.25x` |
|| [Tailcall] | `60,059.40` | `1.68` | `24.26x` |
|| [async-graphql] | `48,458.60` | `2.25` | `19.58x` |
|| [Gqlgen] | `47,950.90` | `5.14` | `19.37x` |
|| [Netflix DGS] | `8,168.72` | `14.93` | `3.30x` |
|| [Apollo GraphQL] | `7,797.65` | `13.06` | `3.15x` |
|| [GraphQL JIT] | `5,034.36` | `19.84` | `2.03x` |
|| [Hasura] | `2,475.51` | `40.29` | `1.00x` |

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
