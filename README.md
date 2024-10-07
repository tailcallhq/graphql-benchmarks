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
|| [Tailcall] | `13,645.00` | `7.29` | `122.52x` |
|| [GraphQL JIT] | `1,106.83` | `89.85` | `9.94x` |
|| [async-graphql] | `1,073.01` | `92.66` | `9.63x` |
|| [Caliban] | `894.77` | `112.16` | `8.03x` |
|| [Gqlgen] | `388.86` | `253.59` | `3.49x` |
|| [Netflix DGS] | `181.07` | `540.32` | `1.63x` |
|| [Apollo GraphQL] | `134.12` | `686.13` | `1.20x` |
|| [Hasura] | `111.37` | `742.31` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `21,704.90` | `4.58` | `47.02x` |
|| [Caliban] | `5,537.95` | `18.12` | `12.00x` |
|| [async-graphql] | `5,316.22` | `18.82` | `11.52x` |
|| [GraphQL JIT] | `1,147.08` | `87.00` | `2.49x` |
|| [Gqlgen] | `1,097.29` | `100.41` | `2.38x` |
|| [Apollo GraphQL] | `906.18` | `110.81` | `1.96x` |
|| [Netflix DGS] | `783.43` | `157.61` | `1.70x` |
|| [Hasura] | `461.59` | `218.80` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `47,641.20` | `2.03` | `29.50x` |
|| [async-graphql] | `25,421.60` | `3.92` | `15.74x` |
|| [Gqlgen] | `24,886.90` | `5.08` | `15.41x` |
|| [Tailcall] | `20,599.50` | `4.87` | `12.76x` |
|| [GraphQL JIT] | `4,541.87` | `21.97` | `2.81x` |
|| [Apollo GraphQL] | `4,050.09` | `28.70` | `2.51x` |
|| [Netflix DGS] | `3,986.76` | `30.54` | `2.47x` |
|| [Hasura] | `1,614.84` | `63.37` | `1.00x` |

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
