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
|| [Tailcall] | `29,452.50` | `3.38` | `125.70x` |
|| [async-graphql] | `2,005.70` | `49.93` | `8.56x` |
|| [Caliban] | `1,771.23` | `56.34` | `7.56x` |
|| [GraphQL JIT] | `1,309.91` | `76.02` | `5.59x` |
|| [Gqlgen] | `789.17` | `125.74` | `3.37x` |
|| [Netflix DGS] | `367.79` | `159.81` | `1.57x` |
|| [Apollo GraphQL] | `261.90` | `373.99` | `1.12x` |
|| [Hasura] | `234.31` | `421.49` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `58,899.50` | `1.69` | `77.91x` |
|| [async-graphql] | `10,356.80` | `9.74` | `13.70x` |
|| [Caliban] | `9,934.80` | `10.39` | `13.14x` |
|| [Gqlgen] | `2,187.51` | `47.48` | `2.89x` |
|| [Apollo GraphQL] | `1,706.22` | `58.55` | `2.26x` |
|| [Netflix DGS] | `1,591.12` | `70.26` | `2.10x` |
|| [GraphQL JIT] | `1,387.43` | `71.97` | `1.84x` |
|| [Hasura] | `755.99` | `133.14` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `67,796.80` | `1.05` | `26.43x` |
|| [Tailcall] | `59,034.80` | `1.71` | `23.01x` |
|| [async-graphql] | `47,717.70` | `2.18` | `18.60x` |
|| [Gqlgen] | `47,529.40` | `5.10` | `18.53x` |
|| [Netflix DGS] | `8,134.51` | `15.06` | `3.17x` |
|| [Apollo GraphQL] | `7,873.52` | `12.98` | `3.07x` |
|| [GraphQL JIT] | `5,286.77` | `18.89` | `2.06x` |
|| [Hasura] | `2,565.12` | `39.54` | `1.00x` |

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
