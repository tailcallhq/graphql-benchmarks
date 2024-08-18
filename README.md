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
|| [Tailcall] | `29,186.30` | `3.41` | `123.49x` |
|| [async-graphql] | `2,035.11` | `49.24` | `8.61x` |
|| [Caliban] | `1,780.94` | `56.10` | `7.54x` |
|| [GraphQL JIT] | `1,314.07` | `75.78` | `5.56x` |
|| [Gqlgen] | `799.67` | `124.11` | `3.38x` |
|| [Netflix DGS] | `361.33` | `207.03` | `1.53x` |
|| [Apollo GraphQL] | `270.87` | `363.12` | `1.15x` |
|| [Hasura] | `236.34` | `414.04` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `58,647.70` | `1.70` | `81.07x` |
|| [async-graphql] | `10,415.10` | `9.65` | `14.40x` |
|| [Caliban] | `9,930.96` | `10.40` | `13.73x` |
|| [Gqlgen] | `2,227.10` | `46.53` | `3.08x` |
|| [Apollo GraphQL] | `1,736.85` | `57.49` | `2.40x` |
|| [Netflix DGS] | `1,586.82` | `71.27` | `2.19x` |
|| [GraphQL JIT] | `1,346.52` | `74.15` | `1.86x` |
|| [Hasura] | `723.44` | `139.49` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `68,434.90` | `1.06` | `28.08x` |
|| [Tailcall] | `59,519.80` | `1.69` | `24.42x` |
|| [async-graphql] | `48,213.80` | `2.11` | `19.78x` |
|| [Gqlgen] | `48,032.30` | `5.07` | `19.71x` |
|| [Netflix DGS] | `8,108.93` | `15.07` | `3.33x` |
|| [Apollo GraphQL] | `7,935.78` | `12.82` | `3.26x` |
|| [GraphQL JIT] | `5,147.01` | `19.40` | `2.11x` |
|| [Hasura] | `2,437.15` | `41.02` | `1.00x` |

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
