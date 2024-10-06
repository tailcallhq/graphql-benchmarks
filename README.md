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
|| [Tailcall] | `13,602.70` | `7.31` | `119.81x` |
|| [GraphQL JIT] | `1,126.90` | `88.27` | `9.93x` |
|| [async-graphql] | `1,083.42` | `91.74` | `9.54x` |
|| [Caliban] | `847.52` | `118.52` | `7.46x` |
|| [Gqlgen] | `388.09` | `254.06` | `3.42x` |
|| [Netflix DGS] | `189.05` | `524.22` | `1.67x` |
|| [Apollo GraphQL] | `132.88` | `692.01` | `1.17x` |
|| [Hasura] | `113.54` | `729.66` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `21,407.00` | `4.64` | `50.58x` |
|| [Caliban] | `5,380.92` | `18.67` | `12.71x` |
|| [async-graphql] | `5,311.74` | `18.81` | `12.55x` |
|| [GraphQL JIT] | `1,174.50` | `84.88` | `2.78x` |
|| [Gqlgen] | `1,133.21` | `96.82` | `2.68x` |
|| [Apollo GraphQL] | `896.74` | `112.01` | `2.12x` |
|| [Netflix DGS] | `818.12` | `149.71` | `1.93x` |
|| [Hasura] | `423.21` | `241.43` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `46,752.40` | `2.08` | `29.71x` |
|| [Gqlgen] | `26,054.70` | `4.82` | `16.56x` |
|| [async-graphql] | `25,695.40` | `3.87` | `16.33x` |
|| [Tailcall] | `20,948.50` | `4.79` | `13.31x` |
|| [GraphQL JIT] | `4,651.37` | `21.46` | `2.96x` |
|| [Netflix DGS] | `4,200.27` | `27.52` | `2.67x` |
|| [Apollo GraphQL] | `4,047.47` | `28.38` | `2.57x` |
|| [Hasura] | `1,573.65` | `65.01` | `1.00x` |

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
