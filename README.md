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
|| [Tailcall] | `30,409.80` | `3.28` | `111.72x` |
|| [async-graphql] | `1,869.13` | `53.96` | `6.87x` |
|| [Caliban] | `1,569.67` | `63.48` | `5.77x` |
|| [Hasura] | `1,547.31` | `64.59` | `5.68x` |
|| [GraphQL JIT] | `1,331.15` | `74.77` | `4.89x` |
|| [Gqlgen] | `770.44` | `128.79` | `2.83x` |
|| [Netflix DGS] | `358.01` | `224.74` | `1.32x` |
|| [Apollo GraphQL] | `272.19` | `361.26` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `62,136.90` | `1.60` | `44.43x` |
|| [async-graphql] | `9,454.06` | `10.64` | `6.76x` |
|| [Caliban] | `9,307.86` | `11.10` | `6.66x` |
|| [Hasura] | `2,506.21` | `39.89` | `1.79x` |
|| [Gqlgen] | `2,158.45` | `47.92` | `1.54x` |
|| [Apollo GraphQL] | `1,757.07` | `56.84` | `1.26x` |
|| [Netflix DGS] | `1,582.36` | `70.62` | `1.13x` |
|| [GraphQL JIT] | `1,398.58` | `71.39` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `67,597.40` | `1.09` | `26.67x` |
|| [Tailcall] | `63,718.90` | `1.58` | `25.14x` |
|| [async-graphql] | `51,188.60` | `2.04` | `20.20x` |
|| [Gqlgen] | `46,807.00` | `5.16` | `18.47x` |
|| [Netflix DGS] | `8,110.59` | `14.73` | `3.20x` |
|| [Apollo GraphQL] | `8,066.03` | `12.60` | `3.18x` |
|| [GraphQL JIT] | `5,241.73` | `19.05` | `2.07x` |
|| [Hasura] | `2,534.19` | `39.37` | `1.00x` |

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
