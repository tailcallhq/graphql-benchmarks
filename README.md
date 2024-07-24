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
|| [Tailcall] | `29,455.70` | `3.37` | `297.45x` |
|| [async-graphql] | `2,024.15` | `49.35` | `20.44x` |
|| [Caliban] | `1,651.56` | `60.76` | `16.68x` |
|| [GraphQL JIT] | `1,366.98` | `72.87` | `13.80x` |
|| [Gqlgen] | `798.81` | `124.27` | `8.07x` |
|| [Netflix DGS] | `357.88` | `199.85` | `3.61x` |
|| [Apollo GraphQL] | `268.67` | `365.44` | `2.71x` |
|| [Hasura] | `99.03` | `565.76` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `59,007.50` | `1.69` | `70.16x` |
|| [async-graphql] | `9,776.62` | `10.43` | `11.62x` |
|| [Caliban] | `9,581.61` | `10.79` | `11.39x` |
|| [Gqlgen] | `2,206.12` | `46.96` | `2.62x` |
|| [Apollo GraphQL] | `1,772.56` | `56.34` | `2.11x` |
|| [Netflix DGS] | `1,587.76` | `70.51` | `1.89x` |
|| [GraphQL JIT] | `1,416.62` | `70.48` | `1.68x` |
|| [Hasura] | `841.05` | `118.68` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `69,562.60` | `1.02` | `27.37x` |
|| [Tailcall] | `60,044.90` | `1.68` | `23.63x` |
|| [async-graphql] | `47,600.40` | `2.23` | `18.73x` |
|| [Gqlgen] | `47,568.70` | `5.08` | `18.72x` |
|| [Netflix DGS] | `8,317.93` | `14.44` | `3.27x` |
|| [Apollo GraphQL] | `8,124.35` | `12.55` | `3.20x` |
|| [GraphQL JIT] | `5,275.46` | `18.93` | `2.08x` |
|| [Hasura] | `2,541.50` | `39.29` | `1.00x` |

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
