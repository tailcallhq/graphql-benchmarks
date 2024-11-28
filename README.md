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
|| [Tailcall] | `22,151.40` | `4.51` | `185.67x` |
|| [GraphQL JIT] | `1,141.60` | `87.12` | `9.57x` |
|| [async-graphql] | `1,106.34` | `89.76` | `9.27x` |
|| [Caliban] | `784.92` | `127.26` | `6.58x` |
|| [Gqlgen] | `375.84` | `262.18` | `3.15x` |
|| [Netflix DGS] | `204.58` | `474.66` | `1.71x` |
|| [Apollo GraphQL] | `132.82` | `689.50` | `1.11x` |
|| [Hasura] | `119.30` | `761.07` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `32,856.80` | `3.04` | `70.48x` |
|| [async-graphql] | `5,691.22` | `17.60` | `12.21x` |
|| [Caliban] | `4,862.24` | `21.07` | `10.43x` |
|| [GraphQL JIT] | `1,180.49` | `84.55` | `2.53x` |
|| [Gqlgen] | `1,084.03` | `101.60` | `2.33x` |
|| [Apollo GraphQL] | `886.88` | `113.18` | `1.90x` |
|| [Netflix DGS] | `874.51` | `115.37` | `1.88x` |
|| [Hasura] | `466.18` | `216.97` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `40,046.20` | `2.49` | `24.71x` |
|| [Caliban] | `33,564.70` | `3.00` | `20.71x` |
|| [async-graphql] | `25,494.20` | `3.96` | `15.73x` |
|| [Gqlgen] | `24,140.90` | `9.02` | `14.89x` |
|| [GraphQL JIT] | `4,647.44` | `21.47` | `2.87x` |
|| [Netflix DGS] | `4,528.48` | `27.20` | `2.79x` |
|| [Apollo GraphQL] | `4,033.73` | `28.27` | `2.49x` |
|| [Hasura] | `1,620.82` | `61.66` | `1.00x` |

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
