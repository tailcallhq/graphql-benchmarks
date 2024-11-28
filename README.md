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
|| [Tailcall] | `21,696.60` | `4.60` | `221.05x` |
|| [GraphQL JIT] | `1,134.02` | `87.74` | `11.55x` |
|| [async-graphql] | `937.29` | `105.92` | `9.55x` |
|| [Caliban] | `716.91` | `140.28` | `7.30x` |
|| [Gqlgen] | `394.94` | `249.61` | `4.02x` |
|| [Netflix DGS] | `186.26` | `518.10` | `1.90x` |
|| [Apollo GraphQL] | `131.84` | `697.35` | `1.34x` |
|| [Hasura] | `98.15` | `783.56` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `33,417.30` | `2.99` | `72.16x` |
|| [async-graphql] | `4,958.13` | `20.18` | `10.71x` |
|| [Caliban] | `4,847.24` | `21.06` | `10.47x` |
|| [GraphQL JIT] | `1,127.95` | `88.49` | `2.44x` |
|| [Gqlgen] | `1,110.40` | `98.78` | `2.40x` |
|| [Apollo GraphQL] | `897.43` | `111.92` | `1.94x` |
|| [Netflix DGS] | `808.48` | `124.12` | `1.75x` |
|| [Hasura] | `463.09` | `217.76` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `40,183.60` | `2.49` | `26.21x` |
|| [Caliban] | `33,739.00` | `2.99` | `22.01x` |
|| [Gqlgen] | `24,264.40` | `8.53` | `15.83x` |
|| [async-graphql] | `23,883.70` | `4.19` | `15.58x` |
|| [GraphQL JIT] | `4,575.50` | `21.79` | `2.98x` |
|| [Netflix DGS] | `4,222.03` | `27.70` | `2.75x` |
|| [Apollo GraphQL] | `4,076.42` | `27.33` | `2.66x` |
|| [Hasura] | `1,532.88` | `65.03` | `1.00x` |

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
