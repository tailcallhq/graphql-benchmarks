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
|| [Tailcall] | `20,368.00` | `4.84` | `177.70x` |
|| [GraphQL JIT] | `1,120.68` | `88.79` | `9.78x` |
|| [async-graphql] | `1,108.59` | `89.57` | `9.67x` |
|| [Caliban] | `844.81` | `118.49` | `7.37x` |
|| [Gqlgen] | `380.36` | `259.17` | `3.32x` |
|| [Netflix DGS] | `187.08` | `522.28` | `1.63x` |
|| [Apollo GraphQL] | `127.63` | `714.06` | `1.11x` |
|| [Hasura] | `114.62` | `758.55` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `32,172.20` | `3.06` | `72.37x` |
|| [Caliban] | `5,533.34` | `18.12` | `12.45x` |
|| [async-graphql] | `5,415.35` | `18.47` | `12.18x` |
|| [GraphQL JIT] | `1,171.95` | `85.11` | `2.64x` |
|| [Gqlgen] | `1,066.72` | `103.33` | `2.40x` |
|| [Apollo GraphQL] | `865.23` | `116.18` | `1.95x` |
|| [Netflix DGS] | `806.54` | `155.93` | `1.81x` |
|| [Hasura] | `444.55` | `229.78` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `46,177.00` | `2.10` | `29.59x` |
|| [Tailcall] | `25,661.60` | `3.88` | `16.45x` |
|| [async-graphql] | `25,551.80` | `3.89` | `16.37x` |
|| [Gqlgen] | `24,203.90` | `5.38` | `15.51x` |
|| [GraphQL JIT] | `4,657.22` | `21.43` | `2.98x` |
|| [Netflix DGS] | `4,133.68` | `27.54` | `2.65x` |
|| [Apollo GraphQL] | `3,922.19` | `29.42` | `2.51x` |
|| [Hasura] | `1,560.43` | `65.80` | `1.00x` |

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
