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
|| [Tailcall] | `29,260.70` | `3.41` | `267.57x` |
|| [async-graphql] | `1,919.39` | `52.34` | `17.55x` |
|| [Caliban] | `1,622.68` | `61.81` | `14.84x` |
|| [GraphQL JIT] | `1,292.80` | `77.04` | `11.82x` |
|| [Gqlgen] | `794.88` | `124.82` | `7.27x` |
|| [Netflix DGS] | `365.03` | `178.06` | `3.34x` |
|| [Apollo GraphQL] | `269.39` | `365.58` | `2.46x` |
|| [Hasura] | `109.36` | `508.11` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `57,529.30` | `1.73` | `66.20x` |
|| [async-graphql] | `9,609.02` | `10.53` | `11.06x` |
|| [Caliban] | `9,386.27` | `11.00` | `10.80x` |
|| [Gqlgen] | `2,207.23` | `46.88` | `2.54x` |
|| [Apollo GraphQL] | `1,753.30` | `56.99` | `2.02x` |
|| [Netflix DGS] | `1,599.20` | `70.59` | `1.84x` |
|| [GraphQL JIT] | `1,359.64` | `73.44` | `1.56x` |
|| [Hasura] | `869.04` | `114.82` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `65,705.90` | `1.19` | `24.63x` |
|| [Tailcall] | `59,131.10` | `1.70` | `22.17x` |
|| [Gqlgen] | `47,757.70` | `4.85` | `17.90x` |
|| [async-graphql] | `47,309.50` | `2.13` | `17.73x` |
|| [Netflix DGS] | `8,202.47` | `14.93` | `3.07x` |
|| [Apollo GraphQL] | `8,071.77` | `12.59` | `3.03x` |
|| [GraphQL JIT] | `4,958.60` | `20.13` | `1.86x` |
|| [Hasura] | `2,667.64` | `37.42` | `1.00x` |

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
