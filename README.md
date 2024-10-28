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
|| [Tailcall] | `21,713.10` | `4.60` | `188.76x` |
|| [GraphQL JIT] | `1,090.43` | `91.16` | `9.48x` |
|| [async-graphql] | `1,006.92` | `98.64` | `8.75x` |
|| [Caliban] | `728.06` | `137.44` | `6.33x` |
|| [Gqlgen] | `393.03` | `250.90` | `3.42x` |
|| [Netflix DGS] | `186.61` | `516.94` | `1.62x` |
|| [Apollo GraphQL] | `131.30` | `698.36` | `1.14x` |
|| [Hasura] | `115.03` | `776.35` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `33,796.60` | `2.96` | `84.79x` |
|| [async-graphql] | `5,212.08` | `19.22` | `13.08x` |
|| [Caliban] | `4,817.55` | `21.29` | `12.09x` |
|| [Gqlgen] | `1,120.66` | `97.35` | `2.81x` |
|| [GraphQL JIT] | `1,116.88` | `89.38` | `2.80x` |
|| [Apollo GraphQL] | `905.04` | `110.77` | `2.27x` |
|| [Netflix DGS] | `807.26` | `124.76` | `2.03x` |
|| [Hasura] | `398.59` | `250.39` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `39,782.70` | `2.52` | `26.26x` |
|| [Caliban] | `32,721.80` | `3.06` | `21.60x` |
|| [Gqlgen] | `24,011.80` | `10.10` | `15.85x` |
|| [async-graphql] | `23,649.80` | `4.25` | `15.61x` |
|| [GraphQL JIT] | `4,578.97` | `21.78` | `3.02x` |
|| [Netflix DGS] | `4,173.56` | `28.66` | `2.75x` |
|| [Apollo GraphQL] | `4,104.74` | `27.45` | `2.71x` |
|| [Hasura] | `1,515.02` | `66.18` | `1.00x` |

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
