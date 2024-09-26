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
|| [Tailcall] | `20,291.70` | `4.86` | `191.58x` |
|| [GraphQL JIT] | `1,100.28` | `90.37` | `10.39x` |
|| [async-graphql] | `1,038.58` | `95.65` | `9.81x` |
|| [Caliban] | `889.60` | `112.12` | `8.40x` |
|| [Gqlgen] | `382.48` | `257.83` | `3.61x` |
|| [Netflix DGS] | `186.87` | `518.46` | `1.76x` |
|| [Apollo GraphQL] | `133.32` | `692.26` | `1.26x` |
|| [Hasura] | `105.92` | `764.83` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `32,306.10` | `3.04` | `70.78x` |
|| [Caliban] | `5,380.84` | `18.67` | `11.79x` |
|| [async-graphql] | `5,125.12` | `19.52` | `11.23x` |
|| [GraphQL JIT] | `1,163.27` | `85.81` | `2.55x` |
|| [Gqlgen] | `1,141.20` | `96.10` | `2.50x` |
|| [Apollo GraphQL] | `880.51` | `114.11` | `1.93x` |
|| [Netflix DGS] | `800.90` | `158.60` | `1.75x` |
|| [Hasura] | `456.46` | `218.51` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `46,675.80` | `2.08` | `30.66x` |
|| [Gqlgen] | `26,101.20` | `4.76` | `17.14x` |
|| [async-graphql] | `24,987.40` | `3.99` | `16.41x` |
|| [Tailcall] | `24,956.20` | `3.99` | `16.39x` |
|| [GraphQL JIT] | `4,549.34` | `21.90` | `2.99x` |
|| [Netflix DGS] | `4,097.39` | `28.02` | `2.69x` |
|| [Apollo GraphQL] | `4,025.11` | `28.95` | `2.64x` |
|| [Hasura] | `1,522.46` | `65.82` | `1.00x` |

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
