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
|| [Tailcall] | `21,360.70` | `4.67` | `191.05x` |
|| [GraphQL JIT] | `1,083.44` | `91.76` | `9.69x` |
|| [async-graphql] | `992.79` | `100.03` | `8.88x` |
|| [Caliban] | `770.69` | `130.03` | `6.89x` |
|| [Gqlgen] | `399.81` | `246.49` | `3.58x` |
|| [Netflix DGS] | `183.33` | `531.60` | `1.64x` |
|| [Apollo GraphQL] | `132.48` | `696.27` | `1.18x` |
|| [Hasura] | `111.81` | `733.79` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `33,059.40` | `3.02` | `75.66x` |
|| [async-graphql] | `5,348.40` | `18.85` | `12.24x` |
|| [Caliban] | `4,800.51` | `21.34` | `10.99x` |
|| [GraphQL JIT] | `1,166.73` | `85.53` | `2.67x` |
|| [Gqlgen] | `1,129.80` | `96.33` | `2.59x` |
|| [Apollo GraphQL] | `905.45` | `110.82` | `2.07x` |
|| [Netflix DGS] | `800.75` | `125.60` | `1.83x` |
|| [Hasura] | `436.93` | `244.22` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `39,227.20` | `2.55` | `25.53x` |
|| [Caliban] | `32,530.60` | `3.07` | `21.18x` |
|| [Gqlgen] | `24,530.00` | `8.26` | `15.97x` |
|| [async-graphql] | `23,633.60` | `4.29` | `15.38x` |
|| [GraphQL JIT] | `4,654.70` | `21.42` | `3.03x` |
|| [Netflix DGS] | `4,184.37` | `28.51` | `2.72x` |
|| [Apollo GraphQL] | `4,098.42` | `27.29` | `2.67x` |
|| [Hasura] | `1,536.27` | `64.99` | `1.00x` |

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
