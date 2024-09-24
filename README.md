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
|| [Tailcall] | `20,471.00` | `4.81` | `151.14x` |
|| [Hasura] | `3,095.00` | `32.44` | `22.85x` |
|| [async-graphql] | `1,081.09` | `91.89` | `7.98x` |
|| [GraphQL JIT] | `1,059.61` | `93.88` | `7.82x` |
|| [Caliban] | `837.66` | `119.84` | `6.18x` |
|| [Gqlgen] | `404.96` | `243.68` | `2.99x` |
|| [Netflix DGS] | `190.14` | `516.67` | `1.40x` |
|| [Apollo GraphQL] | `135.44` | `682.69` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `32,678.80` | `3.01` | `40.15x` |
|| [Caliban] | `5,471.07` | `18.35` | `6.72x` |
|| [async-graphql] | `5,319.44` | `18.79` | `6.54x` |
|| [Hasura] | `3,750.13` | `26.68` | `4.61x` |
|| [Gqlgen] | `1,127.55` | `97.24` | `1.39x` |
|| [GraphQL JIT] | `1,052.45` | `94.76` | `1.29x` |
|| [Apollo GraphQL] | `912.03` | `110.15` | `1.12x` |
|| [Netflix DGS] | `813.86` | `151.69` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `48,273.40` | `2.01` | `12.12x` |
|| [Gqlgen] | `25,929.10` | `4.82` | `6.51x` |
|| [Tailcall] | `25,787.90` | `3.86` | `6.47x` |
|| [async-graphql] | `25,629.30` | `3.90` | `6.43x` |
|| [GraphQL JIT] | `4,378.84` | `22.79` | `1.10x` |
|| [Apollo GraphQL] | `4,104.18` | `28.12` | `1.03x` |
|| [Hasura] | `4,034.82` | `25.18` | `1.01x` |
|| [Netflix DGS] | `3,984.35` | `29.38` | `1.00x` |

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
