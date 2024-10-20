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
|| [Tailcall] | `8,545.89` | `11.68` | `82.53x` |
|| [GraphQL JIT] | `1,118.44` | `88.91` | `10.80x` |
|| [async-graphql] | `1,010.29` | `98.29` | `9.76x` |
|| [Caliban] | `782.52` | `127.64` | `7.56x` |
|| [Gqlgen] | `380.56` | `258.84` | `3.68x` |
|| [Netflix DGS] | `191.53` | `504.79` | `1.85x` |
|| [Apollo GraphQL] | `130.90` | `699.76` | `1.26x` |
|| [Hasura] | `103.54` | `735.79` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `16,291.90` | `6.13` | `36.11x` |
|| [async-graphql] | `5,259.48` | `19.16` | `11.66x` |
|| [Caliban] | `4,812.00` | `21.33` | `10.66x` |
|| [GraphQL JIT] | `1,147.05` | `87.00` | `2.54x` |
|| [Gqlgen] | `1,130.95` | `96.69` | `2.51x` |
|| [Apollo GraphQL] | `897.26` | `111.85` | `1.99x` |
|| [Netflix DGS] | `808.17` | `124.34` | `1.79x` |
|| [Hasura] | `451.20` | `235.23` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `32,520.50` | `3.08` | `20.21x` |
|| [Gqlgen] | `24,289.90` | `7.97` | `15.09x` |
|| [async-graphql] | `23,739.20` | `4.23` | `14.75x` |
|| [Tailcall] | `20,956.20` | `4.80` | `13.02x` |
|| [GraphQL JIT] | `4,502.21` | `22.16` | `2.80x` |
|| [Netflix DGS] | `4,278.72` | `28.15` | `2.66x` |
|| [Apollo GraphQL] | `4,078.82` | `27.75` | `2.53x` |
|| [Hasura] | `1,609.14` | `66.28` | `1.00x` |

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
