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
|| [Tailcall] | `9,823.91` | `10.17` | `82.44x` |
|| [GraphQL JIT] | `1,061.33` | `93.71` | `8.91x` |
|| [async-graphql] | `953.88` | `104.03` | `8.01x` |
|| [Caliban] | `764.07` | `131.11` | `6.41x` |
|| [Gqlgen] | `389.70` | `253.14` | `3.27x` |
|| [Netflix DGS] | `185.38` | `516.38` | `1.56x` |
|| [Apollo GraphQL] | `125.96` | `722.49` | `1.06x` |
|| [Hasura] | `119.16` | `753.08` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `19,676.20` | `5.08` | `48.01x` |
|| [async-graphql] | `5,147.25` | `19.50` | `12.56x` |
|| [Caliban] | `4,827.56` | `21.25` | `11.78x` |
|| [Gqlgen] | `1,117.91` | `97.71` | `2.73x` |
|| [GraphQL JIT] | `1,101.18` | `90.63` | `2.69x` |
|| [Apollo GraphQL] | `859.04` | `116.89` | `2.10x` |
|| [Netflix DGS] | `803.61` | `125.07` | `1.96x` |
|| [Hasura] | `409.86` | `248.85` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `33,062.60` | `3.06` | `23.48x` |
|| [Tailcall] | `26,058.70` | `3.87` | `18.50x` |
|| [Gqlgen] | `24,242.70` | `8.55` | `17.21x` |
|| [async-graphql] | `23,323.70` | `4.32` | `16.56x` |
|| [GraphQL JIT] | `4,455.53` | `22.39` | `3.16x` |
|| [Netflix DGS] | `4,149.48` | `28.55` | `2.95x` |
|| [Apollo GraphQL] | `3,998.37` | `27.43` | `2.84x` |
|| [Hasura] | `1,408.40` | `73.41` | `1.00x` |

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
