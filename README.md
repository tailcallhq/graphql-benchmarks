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
|| [Tailcall] | `29,423.40` | `3.39` | `231.38x` |
|| [async-graphql] | `1,972.15` | `52.15` | `15.51x` |
|| [Caliban] | `1,773.74` | `56.11` | `13.95x` |
|| [GraphQL JIT] | `1,355.03` | `73.53` | `10.66x` |
|| [Gqlgen] | `775.86` | `127.91` | `6.10x` |
|| [Netflix DGS] | `364.97` | `171.10` | `2.87x` |
|| [Apollo GraphQL] | `268.93` | `365.09` | `2.11x` |
|| [Hasura] | `127.17` | `557.90` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `58,246.30` | `1.71` | `66.92x` |
|| [async-graphql] | `10,116.10` | `10.04` | `11.62x` |
|| [Caliban] | `9,906.30` | `10.41` | `11.38x` |
|| [Gqlgen] | `2,111.01` | `49.06` | `2.43x` |
|| [Apollo GraphQL] | `1,745.66` | `57.21` | `2.01x` |
|| [Netflix DGS] | `1,591.27` | `71.27` | `1.83x` |
|| [GraphQL JIT] | `1,382.64` | `72.23` | `1.59x` |
|| [Hasura] | `870.39` | `114.65` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `68,578.80` | `1.06` | `29.11x` |
|| [Tailcall] | `58,468.90` | `1.72` | `24.82x` |
|| [async-graphql] | `48,297.30` | `2.27` | `20.50x` |
|| [Gqlgen] | `46,027.90` | `5.18` | `19.54x` |
|| [Netflix DGS] | `8,304.91` | `14.46` | `3.52x` |
|| [Apollo GraphQL] | `8,045.23` | `12.55` | `3.41x` |
|| [GraphQL JIT] | `5,201.80` | `19.20` | `2.21x` |
|| [Hasura] | `2,356.17` | `42.44` | `1.00x` |

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
