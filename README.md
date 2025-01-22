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
|| [Tailcall] | `23,156.10` | `4.23` | `205.01x` |
|| [GraphQL JIT] | `1,082.17` | `92.00` | `9.58x` |
|| [async-graphql] | `1,070.39` | `92.83` | `9.48x` |
|| [Caliban] | `860.62` | `116.65` | `7.62x` |
|| [Gqlgen] | `396.25` | `249.10` | `3.51x` |
|| [Netflix DGS] | `187.33` | `520.86` | `1.66x` |
|| [Apollo GraphQL] | `129.23` | `708.13` | `1.14x` |
|| [Hasura] | `112.95` | `795.86` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `35,116.30` | `2.79` | `77.24x` |
|| [Caliban] | `5,522.84` | `18.19` | `12.15x` |
|| [async-graphql] | `5,347.47` | `18.70` | `11.76x` |
|| [GraphQL JIT] | `1,125.36` | `88.70` | `2.48x` |
|| [Gqlgen] | `1,105.63` | `99.17` | `2.43x` |
|| [Apollo GraphQL] | `882.19` | `113.82` | `1.94x` |
|| [Netflix DGS] | `802.42` | `152.52` | `1.76x` |
|| [Hasura] | `454.64` | `227.14` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `48,667.40` | `1.99` | `30.96x` |
|| [Tailcall] | `45,502.00` | `2.15` | `28.94x` |
|| [Gqlgen] | `26,173.10` | `4.87` | `16.65x` |
|| [async-graphql] | `26,042.70` | `3.83` | `16.56x` |
|| [GraphQL JIT] | `4,439.47` | `22.47` | `2.82x` |
|| [Netflix DGS] | `4,147.07` | `27.29` | `2.64x` |
|| [Apollo GraphQL] | `3,939.28` | `29.43` | `2.51x` |
|| [Hasura] | `1,572.16` | `65.87` | `1.00x` |

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
