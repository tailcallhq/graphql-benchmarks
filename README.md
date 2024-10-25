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
|| [Tailcall] | `21,599.10` | `4.61` | `188.87x` |
|| [GraphQL JIT] | `1,094.57` | `90.81` | `9.57x` |
|| [async-graphql] | `1,008.34` | `98.47` | `8.82x` |
|| [Caliban] | `804.19` | `124.03` | `7.03x` |
|| [Gqlgen] | `392.35` | `251.20` | `3.43x` |
|| [Netflix DGS] | `188.13` | `514.37` | `1.65x` |
|| [Hasura] | `115.76` | `808.24` | `1.01x` |
|| [Apollo GraphQL] | `114.36` | `787.99` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `33,096.10` | `3.02` | `72.72x` |
|| [async-graphql] | `5,208.11` | `19.26` | `11.44x` |
|| [Caliban] | `4,723.96` | `21.67` | `10.38x` |
|| [GraphQL JIT] | `1,147.06` | `87.02` | `2.52x` |
|| [Gqlgen] | `1,124.96` | `97.16` | `2.47x` |
|| [Apollo GraphQL] | `813.34` | `123.21` | `1.79x` |
|| [Netflix DGS] | `800.66` | `125.95` | `1.76x` |
|| [Hasura] | `455.10` | `227.59` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `40,739.70` | `2.46` | `25.13x` |
|| [Caliban] | `34,083.10` | `2.95` | `21.02x` |
|| [Gqlgen] | `24,341.20` | `9.57` | `15.02x` |
|| [async-graphql] | `23,673.40` | `4.24` | `14.60x` |
|| [GraphQL JIT] | `4,626.18` | `21.57` | `2.85x` |
|| [Netflix DGS] | `4,162.34` | `28.72` | `2.57x` |
|| [Apollo GraphQL] | `3,888.73` | `28.45` | `2.40x` |
|| [Hasura] | `1,621.10` | `66.33` | `1.00x` |

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
