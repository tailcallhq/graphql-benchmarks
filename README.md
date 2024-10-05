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
|| [Tailcall] | `13,554.60` | `7.34` | `117.65x` |
|| [async-graphql] | `1,081.54` | `91.83` | `9.39x` |
|| [GraphQL JIT] | `1,065.40` | `93.23` | `9.25x` |
|| [Caliban] | `914.12` | `109.92` | `7.93x` |
|| [Gqlgen] | `396.87` | `248.35` | `3.44x` |
|| [Netflix DGS] | `189.21` | `522.12` | `1.64x` |
|| [Apollo GraphQL] | `133.68` | `690.79` | `1.16x` |
|| [Hasura] | `115.21` | `772.90` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `21,439.20` | `4.64` | `46.96x` |
|| [Caliban] | `5,649.06` | `17.77` | `12.37x` |
|| [async-graphql] | `5,330.23` | `18.76` | `11.67x` |
|| [Gqlgen] | `1,115.55` | `98.80` | `2.44x` |
|| [GraphQL JIT] | `1,112.67` | `89.63` | `2.44x` |
|| [Apollo GraphQL] | `901.92` | `111.31` | `1.98x` |
|| [Netflix DGS] | `815.11` | `154.94` | `1.79x` |
|| [Hasura] | `456.58` | `224.64` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `47,515.80` | `2.04` | `30.31x` |
|| [Gqlgen] | `25,603.90` | `4.91` | `16.33x` |
|| [async-graphql] | `25,306.50` | `3.94` | `16.14x` |
|| [Tailcall] | `20,836.30` | `4.82` | `13.29x` |
|| [GraphQL JIT] | `4,456.51` | `22.40` | `2.84x` |
|| [Netflix DGS] | `4,141.09` | `27.41` | `2.64x` |
|| [Apollo GraphQL] | `4,022.24` | `28.36` | `2.57x` |
|| [Hasura] | `1,567.54` | `64.22` | `1.00x` |

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
