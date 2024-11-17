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
|| [Tailcall] | `21,672.60` | `4.60` | `183.55x` |
|| [GraphQL JIT] | `1,168.97` | `85.08` | `9.90x` |
|| [async-graphql] | `952.16` | `104.18` | `8.06x` |
|| [Caliban] | `766.28` | `131.15` | `6.49x` |
|| [Gqlgen] | `401.89` | `245.30` | `3.40x` |
|| [Netflix DGS] | `193.05` | `501.16` | `1.64x` |
|| [Apollo GraphQL] | `134.28` | `686.16` | `1.14x` |
|| [Hasura] | `118.07` | `737.03` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `33,284.20` | `3.00` | `76.81x` |
|| [async-graphql] | `4,844.77` | `20.66` | `11.18x` |
|| [Caliban] | `4,791.53` | `21.41` | `11.06x` |
|| [Gqlgen] | `1,139.20` | `95.96` | `2.63x` |
|| [GraphQL JIT] | `1,131.68` | `88.19` | `2.61x` |
|| [Apollo GraphQL] | `913.43` | `109.94` | `2.11x` |
|| [Netflix DGS] | `819.57` | `123.02` | `1.89x` |
|| [Hasura] | `433.33` | `245.01` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `40,311.00` | `2.49` | `26.29x` |
|| [Caliban] | `32,887.70` | `3.03` | `21.45x` |
|| [Gqlgen] | `24,472.30` | `9.60` | `15.96x` |
|| [async-graphql] | `22,865.90` | `4.44` | `14.91x` |
|| [GraphQL JIT] | `4,769.44` | `20.92` | `3.11x` |
|| [Netflix DGS] | `4,254.87` | `27.63` | `2.77x` |
|| [Apollo GraphQL] | `4,143.18` | `27.77` | `2.70x` |
|| [Hasura] | `1,533.29` | `64.94` | `1.00x` |

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
