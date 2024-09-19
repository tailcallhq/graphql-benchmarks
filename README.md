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
|| [Tailcall] | `20,450.80` | `4.82` | `178.30x` |
|| [async-graphql] | `1,092.40` | `90.91` | `9.52x` |
|| [GraphQL JIT] | `1,066.61` | `93.23` | `9.30x` |
|| [Caliban] | `770.01` | `130.58` | `6.71x` |
|| [Gqlgen] | `393.90` | `250.59` | `3.43x` |
|| [Netflix DGS] | `182.63` | `537.59` | `1.59x` |
|| [Apollo GraphQL] | `130.07` | `706.83` | `1.13x` |
|| [Hasura] | `114.70` | `768.57` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `33,382.50` | `2.94` | `73.83x` |
|| [Caliban] | `5,417.07` | `18.56` | `11.98x` |
|| [async-graphql] | `5,327.88` | `18.79` | `11.78x` |
|| [GraphQL JIT] | `1,141.45` | `87.42` | `2.52x` |
|| [Gqlgen] | `1,092.10` | `100.53` | `2.42x` |
|| [Apollo GraphQL] | `889.41` | `113.00` | `1.97x` |
|| [Netflix DGS] | `773.53` | `163.95` | `1.71x` |
|| [Hasura] | `452.17` | `224.12` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `47,657.00` | `2.02` | `29.94x` |
|| [Tailcall] | `26,637.60` | `3.74` | `16.73x` |
|| [async-graphql] | `25,519.60` | `3.91` | `16.03x` |
|| [Gqlgen] | `24,904.20` | `5.12` | `15.64x` |
|| [GraphQL JIT] | `4,453.69` | `22.40` | `2.80x` |
|| [Netflix DGS] | `4,043.34` | `30.12` | `2.54x` |
|| [Apollo GraphQL] | `4,022.94` | `30.22` | `2.53x` |
|| [Hasura] | `1,591.84` | `62.73` | `1.00x` |

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
