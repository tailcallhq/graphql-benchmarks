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
|| [Tailcall] | `19,718.60` | `5.06` | `175.59x` |
|| [GraphQL JIT] | `1,125.20` | `88.40` | `10.02x` |
|| [async-graphql] | `985.82` | `101.34` | `8.78x` |
|| [Caliban] | `790.38` | `125.88` | `7.04x` |
|| [Gqlgen] | `374.73` | `262.97` | `3.34x` |
|| [Netflix DGS] | `191.07` | `505.69` | `1.70x` |
|| [Apollo GraphQL] | `131.78` | `697.97` | `1.17x` |
|| [Hasura] | `112.30` | `708.64` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `31,035.20` | `3.22` | `81.33x` |
|| [async-graphql] | `5,299.10` | `18.93` | `13.89x` |
|| [Caliban] | `4,886.84` | `20.96` | `12.81x` |
|| [GraphQL JIT] | `1,170.85` | `85.24` | `3.07x` |
|| [Gqlgen] | `1,083.07` | `100.42` | `2.84x` |
|| [Apollo GraphQL] | `893.97` | `112.15` | `2.34x` |
|| [Netflix DGS] | `819.87` | `122.43` | `2.15x` |
|| [Hasura] | `381.59` | `261.05` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `38,208.70` | `2.61` | `26.77x` |
|| [Tailcall] | `24,329.80` | `4.11` | `17.05x` |
|| [Gqlgen] | `23,505.80` | `9.35` | `16.47x` |
|| [async-graphql] | `23,375.80` | `4.31` | `16.38x` |
|| [GraphQL JIT] | `4,610.37` | `21.63` | `3.23x` |
|| [Netflix DGS] | `4,202.21` | `28.44` | `2.94x` |
|| [Apollo GraphQL] | `4,093.09` | `27.41` | `2.87x` |
|| [Hasura] | `1,427.13` | `69.87` | `1.00x` |

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
