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
|| [Tailcall] | `17,746.30` | `5.62` | `147.42x` |
|| [GraphQL JIT] | `1,105.04` | `89.89` | `9.18x` |
|| [async-graphql] | `924.53` | `107.32` | `7.68x` |
|| [Caliban] | `708.27` | `141.41` | `5.88x` |
|| [Gqlgen] | `381.34` | `258.34` | `3.17x` |
|| [Netflix DGS] | `190.65` | `510.64` | `1.58x` |
|| [Apollo GraphQL] | `132.68` | `692.49` | `1.10x` |
|| [Hasura] | `120.38` | `777.24` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `30,449.80` | `3.28` | `66.25x` |
|| [async-graphql] | `4,940.79` | `20.27` | `10.75x` |
|| [Caliban] | `4,840.68` | `21.05` | `10.53x` |
|| [GraphQL JIT] | `1,123.50` | `88.85` | `2.44x` |
|| [Gqlgen] | `1,094.58` | `100.42` | `2.38x` |
|| [Apollo GraphQL] | `904.42` | `110.91` | `1.97x` |
|| [Netflix DGS] | `815.94` | `123.71` | `1.78x` |
|| [Hasura] | `459.61` | `242.36` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `37,420.80` | `2.67` | `23.88x` |
|| [Tailcall] | `23,846.70` | `4.20` | `15.22x` |
|| [Gqlgen] | `23,781.80` | `8.69` | `15.18x` |
|| [async-graphql] | `23,149.40` | `4.36` | `14.77x` |
|| [GraphQL JIT] | `4,428.06` | `22.54` | `2.83x` |
|| [Netflix DGS] | `4,279.19` | `27.66` | `2.73x` |
|| [Apollo GraphQL] | `4,077.74` | `27.85` | `2.60x` |
|| [Hasura] | `1,567.10` | `63.68` | `1.00x` |

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
