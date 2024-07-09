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
|| [Tailcall] | `30,507.40` | `3.27` | `106.35x` |
|| [async-graphql] | `1,759.29` | `56.81` | `6.13x` |
|| [Caliban] | `1,582.01` | `62.93` | `5.52x` |
|| [Hasura] | `1,540.62` | `64.80` | `5.37x` |
|| [GraphQL JIT] | `1,421.42` | `73.68` | `4.96x` |
|| [Gqlgen] | `780.42` | `127.14` | `2.72x` |
|| [Netflix DGS] | `358.16` | `141.22` | `1.25x` |
|| [Apollo GraphQL] | `286.85` | `342.37` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `61,937.70` | `1.61` | `42.13x` |
|| [Caliban] | `9,259.70` | `11.15` | `6.30x` |
|| [async-graphql] | `8,765.47` | `11.48` | `5.96x` |
|| [Hasura] | `2,515.21` | `39.73` | `1.71x` |
|| [Gqlgen] | `2,208.59` | `46.86` | `1.50x` |
|| [Apollo GraphQL] | `1,758.88` | `56.79` | `1.20x` |
|| [Netflix DGS] | `1,601.06` | `69.50` | `1.09x` |
|| [GraphQL JIT] | `1,470.30` | `69.19` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `68,333.80` | `1.03` | `26.12x` |
|| [Tailcall] | `64,137.30` | `1.57` | `24.52x` |
|| [async-graphql] | `49,452.80` | `2.11` | `18.91x` |
|| [Gqlgen] | `48,190.50` | `5.06` | `18.42x` |
|| [Netflix DGS] | `8,201.80` | `14.88` | `3.14x` |
|| [Apollo GraphQL] | `7,991.76` | `12.77` | `3.06x` |
|| [GraphQL JIT] | `5,400.21` | `26.22` | `2.06x` |
|| [Hasura] | `2,615.80` | `38.18` | `1.00x` |

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
