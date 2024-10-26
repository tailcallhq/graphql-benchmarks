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
|| [Tailcall] | `21,741.90` | `4.59` | `177.00x` |
|| [GraphQL JIT] | `1,122.48` | `88.65` | `9.14x` |
|| [async-graphql] | `1,002.70` | `99.09` | `8.16x` |
|| [Caliban] | `765.91` | `129.89` | `6.24x` |
|| [Gqlgen] | `386.97` | `254.79` | `3.15x` |
|| [Netflix DGS] | `188.43` | `513.80` | `1.53x` |
|| [Apollo GraphQL] | `132.36` | `694.72` | `1.08x` |
|| [Hasura] | `122.84` | `704.98` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `32,971.90` | `3.03` | `75.26x` |
|| [async-graphql] | `5,203.25` | `19.24` | `11.88x` |
|| [Caliban] | `4,656.93` | `22.04` | `10.63x` |
|| [GraphQL JIT] | `1,160.88` | `85.97` | `2.65x` |
|| [Gqlgen] | `1,145.52` | `95.79` | `2.61x` |
|| [Apollo GraphQL] | `896.68` | `111.94` | `2.05x` |
|| [Netflix DGS] | `812.56` | `123.92` | `1.85x` |
|| [Hasura] | `438.13` | `253.22` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `39,417.70` | `2.55` | `25.08x` |
|| [Caliban] | `32,891.10` | `3.04` | `20.93x` |
|| [Gqlgen] | `24,321.10` | `9.43` | `15.48x` |
|| [async-graphql] | `23,784.60` | `4.25` | `15.13x` |
|| [GraphQL JIT] | `4,629.27` | `21.56` | `2.95x` |
|| [Netflix DGS] | `4,248.44` | `28.22` | `2.70x` |
|| [Apollo GraphQL] | `4,096.44` | `27.61` | `2.61x` |
|| [Hasura] | `1,571.56` | `64.05` | `1.00x` |

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
