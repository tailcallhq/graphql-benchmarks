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
|| [Tailcall] | `21,478.10` | `4.65` | `178.15x` |
|| [GraphQL JIT] | `1,144.96` | `86.89` | `9.50x` |
|| [async-graphql] | `987.40` | `100.50` | `8.19x` |
|| [Caliban] | `777.87` | `127.98` | `6.45x` |
|| [Gqlgen] | `396.18` | `248.81` | `3.29x` |
|| [Netflix DGS] | `190.06` | `507.60` | `1.58x` |
|| [Apollo GraphQL] | `133.93` | `689.62` | `1.11x` |
|| [Hasura] | `120.56` | `727.15` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `32,917.60` | `3.04` | `74.04x` |
|| [async-graphql] | `5,079.76` | `19.70` | `11.43x` |
|| [Caliban] | `4,867.90` | `21.01` | `10.95x` |
|| [Gqlgen] | `1,129.03` | `96.76` | `2.54x` |
|| [GraphQL JIT] | `1,121.27` | `89.03` | `2.52x` |
|| [Apollo GraphQL] | `901.43` | `111.31` | `2.03x` |
|| [Netflix DGS] | `806.68` | `125.05` | `1.81x` |
|| [Hasura] | `444.57` | `227.11` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `39,933.70` | `2.50` | `24.90x` |
|| [Caliban] | `33,331.10` | `3.02` | `20.78x` |
|| [Gqlgen] | `24,076.70` | `8.81` | `15.01x` |
|| [async-graphql] | `23,222.50` | `4.33` | `14.48x` |
|| [GraphQL JIT] | `4,555.25` | `21.90` | `2.84x` |
|| [Netflix DGS] | `4,238.92` | `28.58` | `2.64x` |
|| [Apollo GraphQL] | `4,114.65` | `26.73` | `2.57x` |
|| [Hasura] | `1,603.93` | `66.38` | `1.00x` |

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
