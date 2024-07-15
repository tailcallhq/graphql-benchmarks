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
|| [Tailcall] | `28,619.90` | `3.48` | `110.64x` |
|| [async-graphql] | `1,794.51` | `55.72` | `6.94x` |
|| [Caliban] | `1,547.11` | `64.42` | `5.98x` |
|| [Hasura] | `1,489.73` | `67.16` | `5.76x` |
|| [GraphQL JIT] | `1,269.79` | `78.46` | `4.91x` |
|| [Gqlgen] | `736.60` | `134.65` | `2.85x` |
|| [Netflix DGS] | `354.15` | `167.30` | `1.37x` |
|| [Apollo GraphQL] | `258.67` | `379.64` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `60,556.00` | `1.64` | `47.00x` |
|| [Caliban] | `9,262.33` | `11.14` | `7.19x` |
|| [async-graphql] | `9,233.47` | `11.03` | `7.17x` |
|| [Hasura] | `2,365.20` | `42.24` | `1.84x` |
|| [Gqlgen] | `2,089.30` | `49.59` | `1.62x` |
|| [Apollo GraphQL] | `1,647.59` | `60.62` | `1.28x` |
|| [Netflix DGS] | `1,559.98` | `70.45` | `1.21x` |
|| [GraphQL JIT] | `1,288.29` | `77.51` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `68,219.70` | `1.12` | `27.75x` |
|| [Tailcall] | `63,325.00` | `1.59` | `25.76x` |
|| [async-graphql] | `49,899.90` | `2.03` | `20.30x` |
|| [Gqlgen] | `45,663.30` | `5.33` | `18.58x` |
|| [Netflix DGS] | `7,995.31` | `15.52` | `3.25x` |
|| [Apollo GraphQL] | `7,676.16` | `13.23` | `3.12x` |
|| [GraphQL JIT] | `5,007.30` | `19.94` | `2.04x` |
|| [Hasura] | `2,458.30` | `40.62` | `1.00x` |

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
