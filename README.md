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
|| [Tailcall] | `30,428.00` | `3.27` | `113.50x` |
|| [async-graphql] | `1,900.71` | `52.59` | `7.09x` |
|| [Caliban] | `1,582.57` | `62.79` | `5.90x` |
|| [Hasura] | `1,544.87` | `64.87` | `5.76x` |
|| [GraphQL JIT] | `1,351.71` | `73.66` | `5.04x` |
|| [Gqlgen] | `760.58` | `130.47` | `2.84x` |
|| [Netflix DGS] | `359.93` | `178.74` | `1.34x` |
|| [Apollo GraphQL] | `268.09` | `365.96` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `62,516.70` | `1.59` | `44.80x` |
|| [async-graphql] | `9,572.21` | `10.57` | `6.86x` |
|| [Caliban] | `9,214.10` | `11.22` | `6.60x` |
|| [Hasura] | `2,453.45` | `40.72` | `1.76x` |
|| [Gqlgen] | `2,176.57` | `47.49` | `1.56x` |
|| [Apollo GraphQL] | `1,748.84` | `57.09` | `1.25x` |
|| [Netflix DGS] | `1,599.12` | `69.93` | `1.15x` |
|| [GraphQL JIT] | `1,395.33` | `71.56` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `67,118.40` | `1.11` | `26.71x` |
|| [Tailcall] | `63,754.90` | `1.58` | `25.37x` |
|| [async-graphql] | `51,800.40` | `2.10` | `20.62x` |
|| [Gqlgen] | `47,402.70` | `5.01` | `18.87x` |
|| [Netflix DGS] | `8,247.08` | `14.65` | `3.28x` |
|| [Apollo GraphQL] | `8,017.89` | `12.63` | `3.19x` |
|| [GraphQL JIT] | `5,130.36` | `19.46` | `2.04x` |
|| [Hasura] | `2,512.60` | `39.76` | `1.00x` |

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
