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
|| [Tailcall] | `29,616.50` | `3.36` | `130.91x` |
|| [async-graphql] | `2,006.13` | `50.39` | `8.87x` |
|| [Caliban] | `1,753.70` | `56.68` | `7.75x` |
|| [GraphQL JIT] | `1,343.46` | `74.15` | `5.94x` |
|| [Gqlgen] | `776.02` | `127.89` | `3.43x` |
|| [Netflix DGS] | `368.84` | `211.80` | `1.63x` |
|| [Apollo GraphQL] | `268.54` | `365.32` | `1.19x` |
|| [Hasura] | `226.24` | `435.07` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `58,582.20` | `1.70` | `88.29x` |
|| [async-graphql] | `10,339.70` | `9.81` | `15.58x` |
|| [Caliban] | `9,873.28` | `10.45` | `14.88x` |
|| [Gqlgen] | `2,194.03` | `47.27` | `3.31x` |
|| [Apollo GraphQL] | `1,743.95` | `57.26` | `2.63x` |
|| [Netflix DGS] | `1,614.55` | `69.56` | `2.43x` |
|| [GraphQL JIT] | `1,359.79` | `73.43` | `2.05x` |
|| [Hasura] | `663.49` | `150.44` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `69,142.90` | `1.05` | `27.76x` |
|| [Tailcall] | `58,939.30` | `1.71` | `23.66x` |
|| [Gqlgen] | `47,496.40` | `5.23` | `19.07x` |
|| [async-graphql] | `47,390.20` | `2.23` | `19.03x` |
|| [Netflix DGS] | `8,300.79` | `14.63` | `3.33x` |
|| [Apollo GraphQL] | `8,007.20` | `12.82` | `3.21x` |
|| [GraphQL JIT] | `5,121.20` | `19.50` | `2.06x` |
|| [Hasura] | `2,490.64` | `41.86` | `1.00x` |

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
