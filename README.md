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
|| [Tailcall] | `19,983.10` | `4.93` | `171.06x` |
|| [GraphQL JIT] | `1,138.96` | `87.38` | `9.75x` |
|| [async-graphql] | `1,114.66` | `89.14` | `9.54x` |
|| [Caliban] | `850.37` | `117.89` | `7.28x` |
|| [Gqlgen] | `364.23` | `270.52` | `3.12x` |
|| [Netflix DGS] | `189.27` | `517.96` | `1.62x` |
|| [Apollo GraphQL] | `133.09` | `690.93` | `1.14x` |
|| [Hasura] | `116.82` | `777.77` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `32,859.50` | `2.99` | `71.85x` |
|| [async-graphql] | `5,438.49` | `18.41` | `11.89x` |
|| [Caliban] | `5,401.10` | `18.64` | `11.81x` |
|| [GraphQL JIT] | `1,173.99` | `84.98` | `2.57x` |
|| [Gqlgen] | `1,051.43` | `104.75` | `2.30x` |
|| [Apollo GraphQL] | `901.00` | `111.44` | `1.97x` |
|| [Netflix DGS] | `808.55` | `151.19` | `1.77x` |
|| [Hasura] | `457.34` | `230.79` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `47,295.60` | `2.04` | `29.52x` |
|| [Tailcall] | `26,178.40` | `3.80` | `16.34x` |
|| [async-graphql] | `25,652.10` | `3.88` | `16.01x` |
|| [Gqlgen] | `24,128.30` | `5.35` | `15.06x` |
|| [GraphQL JIT] | `4,556.84` | `21.90` | `2.84x` |
|| [Netflix DGS] | `4,143.23` | `28.28` | `2.59x` |
|| [Apollo GraphQL] | `4,078.90` | `28.12` | `2.55x` |
|| [Hasura] | `1,602.19` | `62.60` | `1.00x` |

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
