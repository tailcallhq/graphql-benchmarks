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
|| [Tailcall] | `28,325.60` | `3.51` | `120.83x` |
|| [async-graphql] | `1,972.80` | `51.59` | `8.42x` |
|| [Caliban] | `1,692.11` | `58.72` | `7.22x` |
|| [GraphQL JIT] | `1,287.76` | `77.35` | `5.49x` |
|| [Gqlgen] | `782.62` | `126.86` | `3.34x` |
|| [Netflix DGS] | `369.04` | `169.42` | `1.57x` |
|| [Apollo GraphQL] | `258.17` | `380.20` | `1.10x` |
|| [Hasura] | `234.42` | `426.14` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `59,060.20` | `1.69` | `76.58x` |
|| [async-graphql] | `9,994.16` | `10.12` | `12.96x` |
|| [Caliban] | `9,866.20` | `10.48` | `12.79x` |
|| [Gqlgen] | `2,228.23` | `46.46` | `2.89x` |
|| [Apollo GraphQL] | `1,703.49` | `58.64` | `2.21x` |
|| [Netflix DGS] | `1,591.29` | `71.10` | `2.06x` |
|| [GraphQL JIT] | `1,336.68` | `74.71` | `1.73x` |
|| [Hasura] | `771.23` | `131.05` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `69,031.10` | `1.04` | `28.45x` |
|| [Tailcall] | `59,343.20` | `1.69` | `24.45x` |
|| [Gqlgen] | `48,296.30` | `5.06` | `19.90x` |
|| [async-graphql] | `47,850.00` | `2.13` | `19.72x` |
|| [Netflix DGS] | `8,220.35` | `14.79` | `3.39x` |
|| [Apollo GraphQL] | `7,903.10` | `12.92` | `3.26x` |
|| [GraphQL JIT] | `5,104.97` | `19.56` | `2.10x` |
|| [Hasura] | `2,426.69` | `41.29` | `1.00x` |

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
