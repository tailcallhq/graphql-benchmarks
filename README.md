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
|| [Tailcall] | `21,432.20` | `4.66` | `180.42x` |
|| [GraphQL JIT] | `1,122.39` | `88.61` | `9.45x` |
|| [async-graphql] | `1,008.27` | `98.40` | `8.49x` |
|| [Caliban] | `766.44` | `130.19` | `6.45x` |
|| [Gqlgen] | `389.51` | `253.03` | `3.28x` |
|| [Netflix DGS] | `185.12` | `521.57` | `1.56x` |
|| [Apollo GraphQL] | `131.95` | `698.47` | `1.11x` |
|| [Hasura] | `118.79` | `758.66` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `32,662.20` | `3.06` | `73.63x` |
|| [async-graphql] | `5,173.02` | `19.37` | `11.66x` |
|| [Caliban] | `4,866.59` | `21.07` | `10.97x` |
|| [GraphQL JIT] | `1,158.93` | `86.10` | `2.61x` |
|| [Gqlgen] | `1,095.35` | `100.36` | `2.47x` |
|| [Apollo GraphQL] | `899.81` | `111.53` | `2.03x` |
|| [Netflix DGS] | `801.61` | `125.42` | `1.81x` |
|| [Hasura] | `443.60` | `231.36` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `39,308.40` | `2.55` | `27.42x` |
|| [Caliban] | `33,791.70` | `2.99` | `23.57x` |
|| [Gqlgen] | `23,881.40` | `8.06` | `16.66x` |
|| [async-graphql] | `23,425.10` | `4.29` | `16.34x` |
|| [GraphQL JIT] | `4,602.22` | `21.67` | `3.21x` |
|| [Netflix DGS] | `4,145.89` | `28.72` | `2.89x` |
|| [Apollo GraphQL] | `4,051.03` | `27.33` | `2.83x` |
|| [Hasura] | `1,433.76` | `70.09` | `1.00x` |

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
