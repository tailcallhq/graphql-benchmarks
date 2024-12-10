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
|| [Tailcall] | `21,296.30` | `4.68` | `186.49x` |
|| [GraphQL JIT] | `1,092.57` | `91.01` | `9.57x` |
|| [async-graphql] | `1,019.54` | `97.40` | `8.93x` |
|| [Caliban] | `718.00` | `139.13` | `6.29x` |
|| [Gqlgen] | `394.29` | `250.16` | `3.45x` |
|| [Netflix DGS] | `185.05` | `521.30` | `1.62x` |
|| [Apollo GraphQL] | `131.79` | `698.53` | `1.15x` |
|| [Hasura] | `114.20` | `780.64` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `32,271.30` | `3.10` | `71.62x` |
|| [async-graphql] | `5,254.63` | `19.05` | `11.66x` |
|| [Caliban] | `4,743.98` | `21.64` | `10.53x` |
|| [GraphQL JIT] | `1,148.91` | `86.89` | `2.55x` |
|| [Gqlgen] | `1,128.38` | `97.00` | `2.50x` |
|| [Apollo GraphQL] | `882.67` | `113.80` | `1.96x` |
|| [Netflix DGS] | `804.60` | `124.93` | `1.79x` |
|| [Hasura] | `450.60` | `226.33` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `39,394.20` | `2.55` | `28.20x` |
|| [Caliban] | `32,624.50` | `3.06` | `23.35x` |
|| [Gqlgen] | `24,737.40` | `10.44` | `17.71x` |
|| [async-graphql] | `23,969.70` | `4.17` | `17.16x` |
|| [GraphQL JIT] | `4,586.89` | `21.75` | `3.28x` |
|| [Netflix DGS] | `4,126.68` | `28.77` | `2.95x` |
|| [Apollo GraphQL] | `4,054.10` | `27.40` | `2.90x` |
|| [Hasura] | `1,397.12` | `71.80` | `1.00x` |

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
