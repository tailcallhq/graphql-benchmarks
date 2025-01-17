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
|| [Tailcall] | `22,379.70` | `4.39` | `197.03x` |
|| [GraphQL JIT] | `1,126.26` | `88.36` | `9.92x` |
|| [async-graphql] | `998.34` | `99.45` | `8.79x` |
|| [Caliban] | `915.87` | `109.51` | `8.06x` |
|| [Gqlgen] | `397.61` | `248.09` | `3.50x` |
|| [Netflix DGS] | `186.19` | `527.89` | `1.64x` |
|| [Apollo GraphQL] | `130.44` | `701.29` | `1.15x` |
|| [Hasura] | `113.59` | `817.11` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `33,716.20` | `2.91` | `73.19x` |
|| [Caliban] | `5,591.15` | `17.96` | `12.14x` |
|| [async-graphql] | `5,343.19` | `18.72` | `11.60x` |
|| [GraphQL JIT] | `1,169.52` | `85.35` | `2.54x` |
|| [Gqlgen] | `1,104.59` | `99.69` | `2.40x` |
|| [Apollo GraphQL] | `880.73` | `114.08` | `1.91x` |
|| [Netflix DGS] | `799.28` | `149.79` | `1.74x` |
|| [Hasura] | `460.66` | `227.54` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `49,476.10` | `1.96` | `30.77x` |
|| [Tailcall] | `44,512.10` | `2.19` | `27.68x` |
|| [Gqlgen] | `25,697.30` | `5.03` | `15.98x` |
|| [async-graphql] | `25,134.10` | `3.97` | `15.63x` |
|| [GraphQL JIT] | `4,647.84` | `21.47` | `2.89x` |
|| [Netflix DGS] | `4,076.55` | `27.87` | `2.53x` |
|| [Apollo GraphQL] | `4,024.49` | `28.79` | `2.50x` |
|| [Hasura] | `1,608.19` | `62.07` | `1.00x` |

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
