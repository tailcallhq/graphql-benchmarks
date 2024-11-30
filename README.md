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
|| [Tailcall] | `22,005.00` | `4.53` | `184.44x` |
|| [GraphQL JIT] | `1,097.60` | `90.70` | `9.20x` |
|| [async-graphql] | `993.60` | `99.91` | `8.33x` |
|| [Caliban] | `692.48` | `144.92` | `5.80x` |
|| [Gqlgen] | `394.77` | `249.85` | `3.31x` |
|| [Netflix DGS] | `188.55` | `514.71` | `1.58x` |
|| [Apollo GraphQL] | `134.54` | `685.01` | `1.13x` |
|| [Hasura] | `119.31` | `752.74` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `33,426.30` | `2.99` | `71.48x` |
|| [async-graphql] | `5,105.93` | `19.67` | `10.92x` |
|| [Caliban] | `4,703.56` | `21.76` | `10.06x` |
|| [GraphQL JIT] | `1,133.57` | `88.07` | `2.42x` |
|| [Gqlgen] | `1,107.37` | `98.88` | `2.37x` |
|| [Apollo GraphQL] | `902.39` | `111.10` | `1.93x` |
|| [Netflix DGS] | `802.30` | `125.32` | `1.72x` |
|| [Hasura] | `467.61` | `234.65` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `40,001.10` | `2.51` | `26.57x` |
|| [Caliban] | `32,685.40` | `3.08` | `21.71x` |
|| [Gqlgen] | `24,465.20` | `7.97` | `16.25x` |
|| [async-graphql] | `24,078.80` | `4.15` | `15.99x` |
|| [GraphQL JIT] | `4,491.10` | `22.22` | `2.98x` |
|| [Netflix DGS] | `4,165.80` | `28.34` | `2.77x` |
|| [Apollo GraphQL] | `4,069.11` | `28.04` | `2.70x` |
|| [Hasura] | `1,505.50` | `67.20` | `1.00x` |

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
