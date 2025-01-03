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
|| [Tailcall] | `20,054.40` | `4.98` | `176.72x` |
|| [GraphQL JIT] | `1,099.14` | `90.51` | `9.69x` |
|| [async-graphql] | `993.38` | `99.94` | `8.75x` |
|| [Caliban] | `763.65` | `131.16` | `6.73x` |
|| [Gqlgen] | `403.07` | `244.63` | `3.55x` |
|| [Netflix DGS] | `187.50` | `515.61` | `1.65x` |
|| [Apollo GraphQL] | `132.85` | `691.19` | `1.17x` |
|| [Hasura] | `113.48` | `815.83` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `32,400.00` | `3.08` | `78.62x` |
|| [async-graphql] | `5,036.85` | `19.87` | `12.22x` |
|| [Caliban] | `4,698.14` | `21.77` | `11.40x` |
|| [GraphQL JIT] | `1,132.61` | `88.09` | `2.75x` |
|| [Gqlgen] | `1,101.66` | `99.29` | `2.67x` |
|| [Apollo GraphQL] | `901.94` | `111.29` | `2.19x` |
|| [Netflix DGS] | `803.86` | `125.09` | `1.95x` |
|| [Hasura] | `412.12` | `246.38` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `38,985.10` | `2.58` | `24.45x` |
|| [Caliban] | `33,689.50` | `2.99` | `21.13x` |
|| [Gqlgen] | `24,871.80` | `11.49` | `15.60x` |
|| [async-graphql] | `23,797.00` | `4.21` | `14.92x` |
|| [GraphQL JIT] | `4,548.05` | `21.94` | `2.85x` |
|| [Netflix DGS] | `4,119.12` | `29.21` | `2.58x` |
|| [Apollo GraphQL] | `4,048.34` | `26.56` | `2.54x` |
|| [Hasura] | `1,594.69` | `66.89` | `1.00x` |

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
