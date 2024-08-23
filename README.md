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
|| [Tailcall] | `29,750.70` | `3.35` | `134.55x` |
|| [async-graphql] | `1,943.32` | `51.62` | `8.79x` |
|| [Caliban] | `1,791.87` | `55.72` | `8.10x` |
|| [GraphQL JIT] | `1,412.17` | `70.54` | `6.39x` |
|| [Gqlgen] | `765.30` | `129.71` | `3.46x` |
|| [Netflix DGS] | `368.84` | `161.63` | `1.67x` |
|| [Apollo GraphQL] | `271.03` | `362.98` | `1.23x` |
|| [Hasura] | `221.11` | `452.80` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `59,536.70` | `1.67` | `88.30x` |
|| [Caliban] | `10,017.90` | `10.30` | `14.86x` |
|| [async-graphql] | `9,952.88` | `10.22` | `14.76x` |
|| [Gqlgen] | `2,141.62` | `48.46` | `3.18x` |
|| [Apollo GraphQL] | `1,764.72` | `56.59` | `2.62x` |
|| [Netflix DGS] | `1,601.95` | `70.41` | `2.38x` |
|| [GraphQL JIT] | `1,432.39` | `69.71` | `2.12x` |
|| [Hasura] | `674.26` | `148.19` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `68,189.30` | `1.06` | `27.81x` |
|| [Tailcall] | `59,960.20` | `1.68` | `24.46x` |
|| [async-graphql] | `46,724.20` | `2.18` | `19.06x` |
|| [Gqlgen] | `46,579.30` | `5.07` | `19.00x` |
|| [Apollo GraphQL] | `8,110.23` | `12.53` | `3.31x` |
|| [Netflix DGS] | `8,053.45` | `15.19` | `3.28x` |
|| [GraphQL JIT] | `5,297.93` | `18.85` | `2.16x` |
|| [Hasura] | `2,451.83` | `40.76` | `1.00x` |

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
