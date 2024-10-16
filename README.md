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
|| [Tailcall] | `8,402.66` | `11.88` | `70.11x` |
|| [GraphQL JIT] | `1,119.72` | `88.77` | `9.34x` |
|| [async-graphql] | `995.10` | `99.84` | `8.30x` |
|| [Caliban] | `747.43` | `134.00` | `6.24x` |
|| [Gqlgen] | `372.11` | `264.73` | `3.10x` |
|| [Netflix DGS] | `184.65` | `526.19` | `1.54x` |
|| [Apollo GraphQL] | `128.28` | `712.78` | `1.07x` |
|| [Hasura] | `119.85` | `749.32` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `16,029.50` | `6.23` | `37.36x` |
|| [async-graphql] | `5,282.01` | `18.99` | `12.31x` |
|| [Caliban] | `4,802.48` | `21.30` | `11.19x` |
|| [GraphQL JIT] | `1,143.45` | `87.25` | `2.66x` |
|| [Gqlgen] | `1,124.13` | `97.45` | `2.62x` |
|| [Apollo GraphQL] | `888.45` | `113.00` | `2.07x` |
|| [Netflix DGS] | `804.79` | `125.19` | `1.88x` |
|| [Hasura] | `429.11` | `240.70` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `32,890.20` | `3.03` | `22.53x` |
|| [Gqlgen] | `24,382.20` | `8.55` | `16.71x` |
|| [async-graphql] | `23,559.30` | `4.28` | `16.14x` |
|| [Tailcall] | `20,633.80` | `4.86` | `14.14x` |
|| [GraphQL JIT] | `4,556.47` | `21.90` | `3.12x` |
|| [Netflix DGS] | `4,134.63` | `28.88` | `2.83x` |
|| [Apollo GraphQL] | `3,968.20` | `28.22` | `2.72x` |
|| [Hasura] | `1,459.55` | `70.06` | `1.00x` |

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
