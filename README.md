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
|| [Tailcall] | `20,025.50` | `4.98` | `165.51x` |
|| [GraphQL JIT] | `1,038.59` | `95.65` | `8.58x` |
|| [async-graphql] | `1,005.83` | `98.67` | `8.31x` |
|| [Caliban] | `704.52` | `141.95` | `5.82x` |
|| [Gqlgen] | `400.88` | `246.12` | `3.31x` |
|| [Netflix DGS] | `184.72` | `522.62` | `1.53x` |
|| [Apollo GraphQL] | `128.67` | `706.95` | `1.06x` |
|| [Hasura] | `120.99` | `710.29` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `31,577.90` | `3.16` | `67.65x` |
|| [async-graphql] | `5,223.85` | `19.27` | `11.19x` |
|| [Caliban] | `4,729.89` | `21.55` | `10.13x` |
|| [Gqlgen] | `1,133.89` | `96.65` | `2.43x` |
|| [GraphQL JIT] | `1,058.29` | `94.29` | `2.27x` |
|| [Apollo GraphQL] | `873.39` | `114.94` | `1.87x` |
|| [Netflix DGS] | `796.48` | `125.83` | `1.71x` |
|| [Hasura] | `466.81` | `225.81` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `36,476.90` | `2.74` | `22.81x` |
|| [Tailcall] | `24,714.40` | `4.05` | `15.45x` |
|| [Gqlgen] | `24,309.90` | `11.41` | `15.20x` |
|| [async-graphql] | `23,578.50` | `4.25` | `14.74x` |
|| [GraphQL JIT] | `4,403.96` | `22.64` | `2.75x` |
|| [Netflix DGS] | `4,172.24` | `28.59` | `2.61x` |
|| [Apollo GraphQL] | `3,937.67` | `28.23` | `2.46x` |
|| [Hasura] | `1,599.43` | `65.43` | `1.00x` |

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
