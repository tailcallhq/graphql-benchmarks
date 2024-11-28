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
|| [Tailcall] | `20,839.30` | `4.79` | `178.09x` |
|| [GraphQL JIT] | `1,119.81` | `88.82` | `9.57x` |
|| [async-graphql] | `985.65` | `100.79` | `8.42x` |
|| [Caliban] | `781.74` | `128.28` | `6.68x` |
|| [Gqlgen] | `396.28` | `248.95` | `3.39x` |
|| [Netflix DGS] | `188.53` | `510.49` | `1.61x` |
|| [Apollo GraphQL] | `130.93` | `702.92` | `1.12x` |
|| [Hasura] | `117.02` | `795.05` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `32,200.00` | `3.10` | `69.26x` |
|| [async-graphql] | `5,105.12` | `19.61` | `10.98x` |
|| [Caliban] | `4,797.35` | `21.31` | `10.32x` |
|| [GraphQL JIT] | `1,154.71` | `86.41` | `2.48x` |
|| [Gqlgen] | `1,102.71` | `98.90` | `2.37x` |
|| [Apollo GraphQL] | `887.63` | `113.03` | `1.91x` |
|| [Netflix DGS] | `806.79` | `124.24` | `1.74x` |
|| [Hasura] | `464.92` | `221.80` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `38,091.80` | `2.63` | `24.18x` |
|| [Caliban] | `33,191.40` | `3.03` | `21.07x` |
|| [Gqlgen] | `24,658.30` | `10.29` | `15.65x` |
|| [async-graphql] | `23,608.20` | `4.27` | `14.98x` |
|| [GraphQL JIT] | `4,530.34` | `22.03` | `2.88x` |
|| [Netflix DGS] | `4,141.85` | `28.76` | `2.63x` |
|| [Apollo GraphQL] | `4,030.42` | `27.66` | `2.56x` |
|| [Hasura] | `1,575.65` | `66.97` | `1.00x` |

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
