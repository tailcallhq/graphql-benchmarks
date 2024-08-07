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
|| [Tailcall] | `29,039.90` | `3.43` | `208.79x` |
|| [async-graphql] | `1,976.18` | `51.26` | `14.21x` |
|| [Caliban] | `1,724.17` | `57.79` | `12.40x` |
|| [GraphQL JIT] | `1,362.00` | `73.13` | `9.79x` |
|| [Gqlgen] | `770.11` | `128.78` | `5.54x` |
|| [Netflix DGS] | `364.39` | `184.52` | `2.62x` |
|| [Apollo GraphQL] | `258.83` | `379.68` | `1.86x` |
|| [Hasura] | `139.09` | `522.77` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `57,888.20` | `1.72` | `65.66x` |
|| [Caliban] | `9,736.94` | `10.61` | `11.04x` |
|| [async-graphql] | `9,483.80` | `10.61` | `10.76x` |
|| [Gqlgen] | `2,130.37` | `48.51` | `2.42x` |
|| [Apollo GraphQL] | `1,683.90` | `59.29` | `1.91x` |
|| [Netflix DGS] | `1,600.37` | `71.14` | `1.82x` |
|| [GraphQL JIT] | `1,371.77` | `72.81` | `1.56x` |
|| [Hasura] | `881.70` | `113.22` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `68,682.90` | `1.03` | `25.42x` |
|| [Tailcall] | `59,306.30` | `1.70` | `21.95x` |
|| [Gqlgen] | `47,084.20` | `5.06` | `17.43x` |
|| [async-graphql] | `46,966.90` | `2.13` | `17.38x` |
|| [Netflix DGS] | `8,201.11` | `14.79` | `3.04x` |
|| [Apollo GraphQL] | `7,767.26` | `13.15` | `2.87x` |
|| [GraphQL JIT] | `5,093.38` | `19.61` | `1.89x` |
|| [Hasura] | `2,701.93` | `37.03` | `1.00x` |

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
