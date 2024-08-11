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
|| [Tailcall] | `29,836.70` | `3.34` | `405.59x` |
|| [Caliban] | `1,767.50` | `56.30` | `24.03x` |
|| [async-graphql] | `1,752.93` | `57.63` | `23.83x` |
|| [GraphQL JIT] | `1,332.04` | `74.75` | `18.11x` |
|| [Gqlgen] | `791.62` | `125.32` | `10.76x` |
|| [Netflix DGS] | `367.96` | `169.78` | `5.00x` |
|| [Apollo GraphQL] | `267.37` | `366.75` | `3.63x` |
|| [Hasura] | `73.56` | `668.46` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `58,859.80` | `1.69` | `66.54x` |
|| [Caliban] | `10,013.40` | `10.30` | `11.32x` |
|| [async-graphql] | `9,026.53` | `11.33` | `10.20x` |
|| [Gqlgen] | `2,204.41` | `46.83` | `2.49x` |
|| [Apollo GraphQL] | `1,726.27` | `57.87` | `1.95x` |
|| [Netflix DGS] | `1,599.25` | `70.71` | `1.81x` |
|| [GraphQL JIT] | `1,392.08` | `71.74` | `1.57x` |
|| [Hasura] | `884.62` | `112.80` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `67,527.50` | `1.07` | `25.21x` |
|| [Tailcall] | `59,940.60` | `1.68` | `22.38x` |
|| [Gqlgen] | `47,635.40` | `5.11` | `17.79x` |
|| [async-graphql] | `43,791.90` | `2.45` | `16.35x` |
|| [Netflix DGS] | `8,288.04` | `14.50` | `3.09x` |
|| [Apollo GraphQL] | `7,922.28` | `12.80` | `2.96x` |
|| [GraphQL JIT] | `5,198.23` | `19.20` | `1.94x` |
|| [Hasura] | `2,678.30` | `37.26` | `1.00x` |

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
