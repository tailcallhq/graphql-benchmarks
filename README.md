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
|| [Tailcall] | `28,531.00` | `3.49` | `246.99x` |
|| [async-graphql] | `2,018.68` | `49.52` | `17.48x` |
|| [Caliban] | `1,723.38` | `57.97` | `14.92x` |
|| [GraphQL JIT] | `1,321.72` | `75.35` | `11.44x` |
|| [Gqlgen] | `796.72` | `124.51` | `6.90x` |
|| [Netflix DGS] | `367.12` | `172.60` | `3.18x` |
|| [Apollo GraphQL] | `266.85` | `367.51` | `2.31x` |
|| [Hasura] | `115.51` | `586.56` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `57,428.80` | `1.73` | `65.03x` |
|| [async-graphql] | `10,288.80` | `9.91` | `11.65x` |
|| [Caliban] | `9,976.64` | `10.35` | `11.30x` |
|| [Gqlgen] | `2,221.63` | `46.58` | `2.52x` |
|| [Apollo GraphQL] | `1,755.02` | `56.90` | `1.99x` |
|| [Netflix DGS] | `1,602.73` | `70.20` | `1.81x` |
|| [GraphQL JIT] | `1,373.60` | `72.70` | `1.56x` |
|| [Hasura] | `883.15` | `112.96` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `67,623.30` | `1.07` | `24.63x` |
|| [Tailcall] | `58,145.30` | `1.73` | `21.18x` |
|| [Gqlgen] | `48,710.90` | `4.97` | `17.74x` |
|| [async-graphql] | `48,162.30` | `2.15` | `17.54x` |
|| [Netflix DGS] | `8,241.28` | `14.69` | `3.00x` |
|| [Apollo GraphQL] | `8,072.63` | `12.59` | `2.94x` |
|| [GraphQL JIT] | `5,189.59` | `19.24` | `1.89x` |
|| [Hasura] | `2,745.16` | `36.47` | `1.00x` |

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
