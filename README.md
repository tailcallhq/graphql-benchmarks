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
|| [Tailcall] | `18,915.90` | `5.22` | `161.13x` |
|| [GraphQL JIT] | `1,123.71` | `88.49` | `9.57x` |
|| [async-graphql] | `1,061.93` | `93.54` | `9.05x` |
|| [Caliban] | `805.16` | `124.67` | `6.86x` |
|| [Gqlgen] | `404.10` | `244.09` | `3.44x` |
|| [Netflix DGS] | `187.18` | `524.59` | `1.59x` |
|| [Apollo GraphQL] | `133.90` | `690.08` | `1.14x` |
|| [Hasura] | `117.40` | `672.34` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `31,754.50` | `3.10` | `76.95x` |
|| [Caliban] | `5,438.78` | `18.47` | `13.18x` |
|| [async-graphql] | `5,340.31` | `18.73` | `12.94x` |
|| [GraphQL JIT] | `1,152.95` | `86.49` | `2.79x` |
|| [Gqlgen] | `1,123.25` | `97.03` | `2.72x` |
|| [Apollo GraphQL] | `902.03` | `111.45` | `2.19x` |
|| [Netflix DGS] | `806.79` | `153.08` | `1.95x` |
|| [Hasura] | `412.69` | `245.57` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `45,564.80` | `2.12` | `30.24x` |
|| [async-graphql] | `25,902.30` | `3.84` | `17.19x` |
|| [Gqlgen] | `25,849.40` | `4.93` | `17.16x` |
|| [Tailcall] | `25,511.10` | `3.90` | `16.93x` |
|| [GraphQL JIT] | `4,520.37` | `22.08` | `3.00x` |
|| [Netflix DGS] | `4,160.33` | `27.40` | `2.76x` |
|| [Apollo GraphQL] | `4,074.95` | `28.83` | `2.70x` |
|| [Hasura] | `1,506.53` | `66.92` | `1.00x` |

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
