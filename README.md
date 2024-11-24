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
|| [Tailcall] | `22,007.30` | `4.53` | `186.25x` |
|| [GraphQL JIT] | `1,089.79` | `91.22` | `9.22x` |
|| [async-graphql] | `994.79` | `100.15` | `8.42x` |
|| [Caliban] | `763.27` | `131.78` | `6.46x` |
|| [Gqlgen] | `394.03` | `250.28` | `3.33x` |
|| [Netflix DGS] | `192.27` | `501.34` | `1.63x` |
|| [Apollo GraphQL] | `132.75` | `694.16` | `1.12x` |
|| [Hasura] | `118.16` | `766.32` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `33,485.00` | `2.98` | `73.33x` |
|| [async-graphql] | `5,230.44` | `19.19` | `11.45x` |
|| [Caliban] | `4,749.65` | `21.58` | `10.40x` |
|| [GraphQL JIT] | `1,140.78` | `87.48` | `2.50x` |
|| [Gqlgen] | `1,075.11` | `102.47` | `2.35x` |
|| [Apollo GraphQL] | `900.01` | `111.56` | `1.97x` |
|| [Netflix DGS] | `821.80` | `122.39` | `1.80x` |
|| [Hasura] | `456.63` | `221.04` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `40,751.60` | `2.46` | `25.45x` |
|| [Caliban] | `32,557.10` | `3.07` | `20.33x` |
|| [Gqlgen] | `23,894.90` | `8.73` | `14.92x` |
|| [async-graphql] | `23,446.00` | `4.29` | `14.64x` |
|| [GraphQL JIT] | `4,579.75` | `21.77` | `2.86x` |
|| [Netflix DGS] | `4,262.65` | `27.88` | `2.66x` |
|| [Apollo GraphQL] | `4,056.77` | `27.54` | `2.53x` |
|| [Hasura] | `1,601.23` | `63.86` | `1.00x` |

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
