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
|| [Tailcall] | `26,364.30` | `3.78` | `114.08x` |
|| [async-graphql] | `2,016.50` | `49.56` | `8.73x` |
|| [Caliban] | `1,777.13` | `55.92` | `7.69x` |
|| [GraphQL JIT] | `1,345.16` | `73.99` | `5.82x` |
|| [Gqlgen] | `687.44` | `144.34` | `2.97x` |
|| [Netflix DGS] | `369.66` | `170.59` | `1.60x` |
|| [Apollo GraphQL] | `266.95` | `367.11` | `1.16x` |
|| [Hasura] | `231.11` | `429.17` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `59,276.90` | `1.68` | `77.05x` |
|| [async-graphql] | `10,487.80` | `9.67` | `13.63x` |
|| [Caliban] | `9,829.05` | `10.51` | `12.78x` |
|| [Gqlgen] | `1,929.86` | `53.67` | `2.51x` |
|| [Apollo GraphQL] | `1,702.33` | `58.67` | `2.21x` |
|| [Netflix DGS] | `1,610.56` | `69.41` | `2.09x` |
|| [GraphQL JIT] | `1,396.06` | `71.53` | `1.81x` |
|| [Hasura] | `769.29` | `129.69` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `67,584.60` | `1.12` | `27.70x` |
|| [Tailcall] | `59,055.50` | `1.70` | `24.20x` |
|| [async-graphql] | `48,137.30` | `2.20` | `19.73x` |
|| [Gqlgen] | `45,254.60` | `5.42` | `18.55x` |
|| [Netflix DGS] | `8,316.23` | `14.44` | `3.41x` |
|| [Apollo GraphQL] | `7,771.56` | `13.20` | `3.18x` |
|| [GraphQL JIT] | `5,230.76` | `19.08` | `2.14x` |
|| [Hasura] | `2,440.06` | `40.90` | `1.00x` |

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
