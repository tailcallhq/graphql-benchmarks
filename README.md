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
|| [Tailcall] | `27,997.70` | `3.56` | `117.04x` |
|| [async-graphql] | `2,036.08` | `49.10` | `8.51x` |
|| [Caliban] | `1,722.80` | `58.23` | `7.20x` |
|| [GraphQL JIT] | `1,312.86` | `75.86` | `5.49x` |
|| [Gqlgen] | `806.00` | `123.17` | `3.37x` |
|| [Netflix DGS] | `364.68` | `165.55` | `1.52x` |
|| [Apollo GraphQL] | `273.32` | `359.78` | `1.14x` |
|| [Hasura] | `239.22` | `410.21` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `58,018.60` | `1.72` | `83.80x` |
|| [async-graphql] | `10,379.60` | `9.71` | `14.99x` |
|| [Caliban] | `9,838.27` | `10.50` | `14.21x` |
|| [Gqlgen] | `2,188.91` | `47.24` | `3.16x` |
|| [Apollo GraphQL] | `1,761.61` | `56.69` | `2.54x` |
|| [Netflix DGS] | `1,584.51` | `71.26` | `2.29x` |
|| [GraphQL JIT] | `1,347.07` | `74.12` | `1.95x` |
|| [Hasura] | `692.38` | `144.38` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `66,283.00` | `1.07` | `27.45x` |
|| [Tailcall] | `58,856.40` | `1.72` | `24.38x` |
|| [async-graphql] | `47,899.00` | `2.13` | `19.84x` |
|| [Gqlgen] | `47,487.30` | `5.23` | `19.67x` |
|| [Netflix DGS] | `8,144.18` | `14.74` | `3.37x` |
|| [Apollo GraphQL] | `8,054.02` | `12.60` | `3.34x` |
|| [GraphQL JIT] | `5,191.26` | `19.23` | `2.15x` |
|| [Hasura] | `2,414.33` | `41.33` | `1.00x` |

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
