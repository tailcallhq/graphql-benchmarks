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
|| [Tailcall] | `18,109.60` | `5.51` | `152.02x` |
|| [GraphQL JIT] | `1,065.83` | `93.27` | `8.95x` |
|| [async-graphql] | `986.62` | `100.81` | `8.28x` |
|| [Caliban] | `721.85` | `138.55` | `6.06x` |
|| [Gqlgen] | `402.12` | `244.93` | `3.38x` |
|| [Netflix DGS] | `181.71` | `530.64` | `1.53x` |
|| [Apollo GraphQL] | `132.71` | `694.95` | `1.11x` |
|| [Hasura] | `119.13` | `769.82` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `30,378.20` | `3.29` | `71.65x` |
|| [async-graphql] | `5,142.12` | `19.59` | `12.13x` |
|| [Caliban] | `4,846.17` | `21.08` | `11.43x` |
|| [GraphQL JIT] | `1,157.43` | `86.21` | `2.73x` |
|| [Gqlgen] | `1,136.25` | `96.56` | `2.68x` |
|| [Apollo GraphQL] | `903.85` | `111.08` | `2.13x` |
|| [Netflix DGS] | `798.82` | `125.74` | `1.88x` |
|| [Hasura] | `423.97` | `237.81` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `38,473.00` | `2.60` | `24.30x` |
|| [Gqlgen] | `24,644.10` | `10.26` | `15.56x` |
|| [Tailcall] | `24,116.30` | `4.15` | `15.23x` |
|| [async-graphql] | `23,696.80` | `4.25` | `14.97x` |
|| [GraphQL JIT] | `4,577.97` | `21.78` | `2.89x` |
|| [Netflix DGS] | `4,176.18` | `28.51` | `2.64x` |
|| [Apollo GraphQL] | `3,996.12` | `28.86` | `2.52x` |
|| [Hasura] | `1,583.34` | `63.00` | `1.00x` |

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
