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
|| [Tailcall] | `21,812.80` | `4.57` | `189.22x` |
|| [GraphQL JIT] | `1,133.41` | `87.77` | `9.83x` |
|| [async-graphql] | `1,021.28` | `97.26` | `8.86x` |
|| [Caliban] | `797.14` | `125.48` | `6.91x` |
|| [Gqlgen] | `388.18` | `254.08` | `3.37x` |
|| [Netflix DGS] | `192.30` | `502.50` | `1.67x` |
|| [Apollo GraphQL] | `127.96` | `712.91` | `1.11x` |
|| [Hasura] | `115.28` | `776.46` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `33,134.10` | `3.02` | `72.96x` |
|| [async-graphql] | `5,280.29` | `19.00` | `11.63x` |
|| [Caliban] | `4,987.16` | `20.47` | `10.98x` |
|| [GraphQL JIT] | `1,164.43` | `85.69` | `2.56x` |
|| [Gqlgen] | `1,113.64` | `98.56` | `2.45x` |
|| [Apollo GraphQL] | `834.95` | `120.44` | `1.84x` |
|| [Netflix DGS] | `817.03` | `123.55` | `1.80x` |
|| [Hasura] | `454.15` | `227.46` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `40,602.30` | `2.46` | `25.86x` |
|| [Caliban] | `34,072.30` | `2.94` | `21.70x` |
|| [Gqlgen] | `24,035.10` | `8.77` | `15.31x` |
|| [async-graphql] | `23,907.60` | `4.19` | `15.23x` |
|| [GraphQL JIT] | `4,613.64` | `21.60` | `2.94x` |
|| [Netflix DGS] | `4,249.49` | `28.24` | `2.71x` |
|| [Apollo GraphQL] | `3,925.62` | `28.07` | `2.50x` |
|| [Hasura] | `1,570.17` | `67.59` | `1.00x` |

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
