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
|| [Tailcall] | `29,625.10` | `3.36` | `308.88x` |
|| [async-graphql] | `2,043.10` | `48.88` | `21.30x` |
|| [Caliban] | `1,666.93` | `60.03` | `17.38x` |
|| [GraphQL JIT] | `1,364.90` | `72.94` | `14.23x` |
|| [Gqlgen] | `760.04` | `130.59` | `7.92x` |
|| [Netflix DGS] | `359.38` | `195.52` | `3.75x` |
|| [Apollo GraphQL] | `270.17` | `363.15` | `2.82x` |
|| [Hasura] | `95.91` | `578.11` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `58,573.30` | `1.70` | `68.49x` |
|| [async-graphql] | `9,829.73` | `10.33` | `11.49x` |
|| [Caliban] | `9,692.33` | `10.67` | `11.33x` |
|| [Gqlgen] | `2,153.50` | `48.04` | `2.52x` |
|| [Apollo GraphQL] | `1,738.75` | `57.39` | `2.03x` |
|| [Netflix DGS] | `1,596.11` | `69.81` | `1.87x` |
|| [GraphQL JIT] | `1,392.17` | `71.72` | `1.63x` |
|| [Hasura] | `855.23` | `116.65` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `68,097.40` | `1.12` | `26.33x` |
|| [Tailcall] | `59,115.00` | `1.71` | `22.85x` |
|| [async-graphql] | `47,854.30` | `2.11` | `18.50x` |
|| [Gqlgen] | `45,804.00` | `5.55` | `17.71x` |
|| [Netflix DGS] | `8,138.46` | `14.82` | `3.15x` |
|| [Apollo GraphQL] | `8,052.23` | `12.63` | `3.11x` |
|| [GraphQL JIT] | `5,243.88` | `19.04` | `2.03x` |
|| [Hasura] | `2,586.54` | `38.58` | `1.00x` |

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
