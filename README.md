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
|| [Tailcall] | `20,031.60` | `4.92` | `175.08x` |
|| [GraphQL JIT] | `1,070.31` | `92.92` | `9.35x` |
|| [async-graphql] | `1,047.64` | `94.85` | `9.16x` |
|| [Caliban] | `846.94` | `118.50` | `7.40x` |
|| [Gqlgen] | `405.40` | `243.45` | `3.54x` |
|| [Netflix DGS] | `185.17` | `530.92` | `1.62x` |
|| [Apollo GraphQL] | `133.43` | `690.27` | `1.17x` |
|| [Hasura] | `114.42` | `807.14` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `32,398.30` | `3.03` | `77.60x` |
|| [Caliban] | `5,308.55` | `18.96` | `12.72x` |
|| [async-graphql] | `5,303.94` | `18.85` | `12.70x` |
|| [Gqlgen] | `1,123.68` | `97.49` | `2.69x` |
|| [GraphQL JIT] | `1,114.15` | `89.54` | `2.67x` |
|| [Apollo GraphQL] | `908.78` | `110.55` | `2.18x` |
|| [Netflix DGS] | `800.74` | `153.94` | `1.92x` |
|| [Hasura] | `417.48` | `241.27` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `46,027.50` | `2.10` | `29.95x` |
|| [Gqlgen] | `25,958.00` | `4.76` | `16.89x` |
|| [async-graphql] | `25,637.80` | `3.89` | `16.68x` |
|| [Tailcall] | `25,618.20` | `3.88` | `16.67x` |
|| [GraphQL JIT] | `4,494.49` | `22.20` | `2.92x` |
|| [Apollo GraphQL] | `4,138.30` | `27.58` | `2.69x` |
|| [Netflix DGS] | `4,038.75` | `29.66` | `2.63x` |
|| [Hasura] | `1,536.77` | `65.10` | `1.00x` |

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
