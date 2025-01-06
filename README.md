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
|| [Tailcall] | `20,544.50` | `4.86` | `177.41x` |
|| [GraphQL JIT] | `1,070.40` | `92.84` | `9.24x` |
|| [async-graphql] | `939.59` | `105.63` | `8.11x` |
|| [Caliban] | `757.37` | `131.92` | `6.54x` |
|| [Gqlgen] | `400.61` | `246.05` | `3.46x` |
|| [Netflix DGS] | `176.99` | `546.37` | `1.53x` |
|| [Apollo GraphQL] | `132.50` | `695.22` | `1.14x` |
|| [Hasura] | `115.80` | `804.92` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `31,911.90` | `3.13` | `77.28x` |
|| [async-graphql] | `4,958.19` | `20.19` | `12.01x` |
|| [Caliban] | `4,707.60` | `21.73` | `11.40x` |
|| [Gqlgen] | `1,141.55` | `95.54` | `2.76x` |
|| [GraphQL JIT] | `1,098.99` | `90.82` | `2.66x` |
|| [Apollo GraphQL] | `894.50` | `112.22` | `2.17x` |
|| [Netflix DGS] | `777.59` | `129.45` | `1.88x` |
|| [Hasura] | `412.92` | `246.64` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `39,107.80` | `2.56` | `26.15x` |
|| [Caliban] | `33,302.40` | `3.01` | `22.27x` |
|| [Gqlgen] | `24,909.80` | `10.88` | `16.66x` |
|| [async-graphql] | `22,991.70` | `4.36` | `15.37x` |
|| [GraphQL JIT] | `4,466.28` | `22.33` | `2.99x` |
|| [Apollo GraphQL] | `4,053.95` | `28.06` | `2.71x` |
|| [Netflix DGS] | `3,981.26` | `29.32` | `2.66x` |
|| [Hasura] | `1,495.53` | `66.64` | `1.00x` |

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
