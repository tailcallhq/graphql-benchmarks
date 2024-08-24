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
|| [Tailcall] | `30,070.20` | `3.31` | `127.09x` |
|| [async-graphql] | `2,029.92` | `49.25` | `8.58x` |
|| [Caliban] | `1,738.06` | `57.41` | `7.35x` |
|| [GraphQL JIT] | `1,360.03` | `73.19` | `5.75x` |
|| [Gqlgen] | `724.78` | `136.81` | `3.06x` |
|| [Netflix DGS] | `363.83` | `171.52` | `1.54x` |
|| [Apollo GraphQL] | `271.29` | `362.17` | `1.15x` |
|| [Hasura] | `236.61` | `432.86` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `59,470.70` | `1.68` | `76.95x` |
|| [async-graphql] | `10,365.10` | `9.82` | `13.41x` |
|| [Caliban] | `9,824.41` | `10.50` | `12.71x` |
|| [Gqlgen] | `2,075.71` | `49.93` | `2.69x` |
|| [Apollo GraphQL] | `1,767.88` | `56.50` | `2.29x` |
|| [Netflix DGS] | `1,579.26` | `70.92` | `2.04x` |
|| [GraphQL JIT] | `1,408.93` | `70.86` | `1.82x` |
|| [Hasura] | `772.88` | `133.53` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `68,254.80` | `1.08` | `27.95x` |
|| [Tailcall] | `59,693.20` | `1.69` | `24.44x` |
|| [async-graphql] | `48,437.80` | `2.12` | `19.83x` |
|| [Gqlgen] | `44,995.90` | `5.15` | `18.42x` |
|| [Netflix DGS] | `8,088.04` | `14.93` | `3.31x` |
|| [Apollo GraphQL] | `8,080.31` | `12.62` | `3.31x` |
|| [GraphQL JIT] | `5,263.47` | `18.97` | `2.15x` |
|| [Hasura] | `2,442.46` | `40.85` | `1.00x` |

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
