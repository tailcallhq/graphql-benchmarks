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
|| [Tailcall] | `21,841.70` | `4.57` | `188.49x` |
|| [GraphQL JIT] | `1,095.62` | `90.71` | `9.45x` |
|| [async-graphql] | `988.55` | `100.45` | `8.53x` |
|| [Caliban] | `771.92` | `128.95` | `6.66x` |
|| [Gqlgen] | `387.51` | `254.26` | `3.34x` |
|| [Netflix DGS] | `191.30` | `504.48` | `1.65x` |
|| [Apollo GraphQL] | `122.96` | `739.08` | `1.06x` |
|| [Hasura] | `115.88` | `771.12` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `33,394.70` | `2.99` | `78.48x` |
|| [async-graphql] | `5,149.68` | `19.45` | `12.10x` |
|| [Caliban] | `4,679.27` | `21.94` | `11.00x` |
|| [GraphQL JIT] | `1,141.25` | `87.48` | `2.68x` |
|| [Gqlgen] | `1,112.46` | `98.74` | `2.61x` |
|| [Apollo GraphQL] | `821.69` | `122.30` | `1.93x` |
|| [Netflix DGS] | `812.75` | `123.33` | `1.91x` |
|| [Hasura] | `425.53` | `236.29` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `39,998.10` | `2.51` | `25.01x` |
|| [Caliban] | `32,841.10` | `3.06` | `20.54x` |
|| [Gqlgen] | `24,114.60` | `9.37` | `15.08x` |
|| [async-graphql] | `23,481.30` | `4.28` | `14.68x` |
|| [GraphQL JIT] | `4,438.22` | `22.48` | `2.78x` |
|| [Netflix DGS] | `4,205.16` | `28.20` | `2.63x` |
|| [Apollo GraphQL] | `3,864.86` | `29.18` | `2.42x` |
|| [Hasura] | `1,599.06` | `65.61` | `1.00x` |

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
