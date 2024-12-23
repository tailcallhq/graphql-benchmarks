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
|| [Tailcall] | `20,786.60` | `4.80` | `177.48x` |
|| [GraphQL JIT] | `1,135.10` | `87.59` | `9.69x` |
|| [async-graphql] | `943.31` | `105.35` | `8.05x` |
|| [Caliban] | `779.97` | `128.72` | `6.66x` |
|| [Gqlgen] | `387.11` | `254.45` | `3.31x` |
|| [Netflix DGS] | `189.43` | `510.31` | `1.62x` |
|| [Apollo GraphQL] | `131.27` | `696.78` | `1.12x` |
|| [Hasura] | `117.12` | `775.15` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `32,397.00` | `3.09` | `77.04x` |
|| [async-graphql] | `4,997.87` | `20.07` | `11.88x` |
|| [Caliban] | `4,900.17` | `20.86` | `11.65x` |
|| [GraphQL JIT] | `1,142.16` | `87.37` | `2.72x` |
|| [Gqlgen] | `1,116.88` | `98.22` | `2.66x` |
|| [Apollo GraphQL] | `903.11` | `111.35` | `2.15x` |
|| [Netflix DGS] | `812.64` | `123.60` | `1.93x` |
|| [Hasura] | `420.53` | `239.48` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `38,941.10` | `2.58` | `24.55x` |
|| [Caliban] | `32,876.30` | `3.07` | `20.73x` |
|| [Gqlgen] | `23,948.00` | `10.08` | `15.10x` |
|| [async-graphql] | `23,211.50` | `4.33` | `14.63x` |
|| [GraphQL JIT] | `4,446.52` | `22.44` | `2.80x` |
|| [Netflix DGS] | `4,180.89` | `28.89` | `2.64x` |
|| [Apollo GraphQL] | `4,107.50` | `26.92` | `2.59x` |
|| [Hasura] | `1,586.26` | `65.72` | `1.00x` |

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
