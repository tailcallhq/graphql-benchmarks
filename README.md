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
|| [Tailcall] | `20,161.70` | `4.89` | `174.64x` |
|| [GraphQL JIT] | `1,105.83` | `89.99` | `9.58x` |
|| [async-graphql] | `1,101.20` | `90.18` | `9.54x` |
|| [Caliban] | `881.32` | `113.76` | `7.63x` |
|| [Gqlgen] | `401.48` | `245.81` | `3.48x` |
|| [Netflix DGS] | `191.06` | `511.71` | `1.65x` |
|| [Apollo GraphQL] | `127.58` | `719.43` | `1.11x` |
|| [Hasura] | `115.45` | `735.32` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `32,621.10` | `3.01` | `69.45x` |
|| [Caliban] | `5,491.75` | `18.27` | `11.69x` |
|| [async-graphql] | `5,425.08` | `18.42` | `11.55x` |
|| [GraphQL JIT] | `1,161.42` | `85.94` | `2.47x` |
|| [Gqlgen] | `1,114.99` | `98.81` | `2.37x` |
|| [Apollo GraphQL] | `866.02` | `116.07` | `1.84x` |
|| [Netflix DGS] | `804.32` | `152.03` | `1.71x` |
|| [Hasura] | `469.70` | `213.53` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `47,826.90` | `2.03` | `30.33x` |
|| [async-graphql] | `25,734.70` | `3.88` | `16.32x` |
|| [Gqlgen] | `25,695.70` | `4.99` | `16.30x` |
|| [Tailcall] | `25,297.90` | `3.94` | `16.04x` |
|| [GraphQL JIT] | `4,512.17` | `22.12` | `2.86x` |
|| [Netflix DGS] | `4,178.69` | `27.42` | `2.65x` |
|| [Apollo GraphQL] | `3,928.61` | `29.56` | `2.49x` |
|| [Hasura] | `1,576.73` | `67.44` | `1.00x` |

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
