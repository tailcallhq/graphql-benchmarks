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
|| [Tailcall] | `29,119.50` | `3.42` | `109.00x` |
|| [Hasura] | `4,876.64` | `20.59` | `18.25x` |
|| [async-graphql] | `1,931.93` | `52.54` | `7.23x` |
|| [Caliban] | `1,659.28` | `60.07` | `6.21x` |
|| [GraphQL JIT] | `1,409.37` | `70.67` | `5.28x` |
|| [Gqlgen] | `798.51` | `124.28` | `2.99x` |
|| [Netflix DGS] | `360.44` | `222.86` | `1.35x` |
|| [Apollo GraphQL] | `267.14` | `367.34` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `57,644.70` | `1.73` | `39.86x` |
|| [Caliban] | `9,498.12` | `10.90` | `6.57x` |
|| [async-graphql] | `9,405.36` | `10.82` | `6.50x` |
|| [Hasura] | `6,227.36` | `16.33` | `4.31x` |
|| [Gqlgen] | `2,216.68` | `46.59` | `1.53x` |
|| [Apollo GraphQL] | `1,749.16` | `57.10` | `1.21x` |
|| [Netflix DGS] | `1,580.84` | `70.22` | `1.09x` |
|| [GraphQL JIT] | `1,446.26` | `69.05` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `67,476.00` | `1.10` | `12.43x` |
|| [Tailcall] | `58,824.30` | `1.71` | `10.84x` |
|| [Gqlgen] | `47,844.60` | `4.91` | `8.81x` |
|| [async-graphql] | `47,312.90` | `2.14` | `8.72x` |
|| [Netflix DGS] | `8,107.78` | `15.08` | `1.49x` |
|| [Apollo GraphQL] | `8,084.48` | `12.65` | `1.49x` |
|| [Hasura] | `6,287.69` | `15.94` | `1.16x` |
|| [GraphQL JIT] | `5,428.77` | `18.39` | `1.00x` |

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
