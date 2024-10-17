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
|| [Tailcall] | `7,910.11` | `12.61` | `67.03x` |
|| [GraphQL JIT] | `1,114.84` | `89.21` | `9.45x` |
|| [async-graphql] | `1,010.20` | `98.22` | `8.56x` |
|| [Caliban] | `740.87` | `135.36` | `6.28x` |
|| [Gqlgen] | `394.67` | `250.20` | `3.34x` |
|| [Netflix DGS] | `188.61` | `511.80` | `1.60x` |
|| [Apollo GraphQL] | `128.49` | `710.81` | `1.09x` |
|| [Hasura] | `118.01` | `752.97` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `15,308.00` | `6.53` | `34.93x` |
|| [async-graphql] | `5,278.54` | `18.96` | `12.04x` |
|| [Caliban] | `4,857.88` | `21.07` | `11.08x` |
|| [GraphQL JIT] | `1,146.89` | `87.00` | `2.62x` |
|| [Gqlgen] | `1,128.01` | `97.22` | `2.57x` |
|| [Apollo GraphQL] | `888.28` | `113.02` | `2.03x` |
|| [Netflix DGS] | `809.72` | `124.44` | `1.85x` |
|| [Hasura] | `438.27` | `243.24` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `33,214.10` | `3.04` | `22.22x` |
|| [Gqlgen] | `24,275.00` | `9.03` | `16.24x` |
|| [async-graphql] | `23,960.80` | `4.20` | `16.03x` |
|| [Tailcall] | `20,465.00` | `4.90` | `13.69x` |
|| [GraphQL JIT] | `4,608.29` | `21.65` | `3.08x` |
|| [Netflix DGS] | `4,223.06` | `28.38` | `2.83x` |
|| [Apollo GraphQL] | `4,039.86` | `27.82` | `2.70x` |
|| [Hasura] | `1,494.45` | `70.00` | `1.00x` |

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
