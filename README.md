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
|| [Tailcall] | `21,993.90` | `4.46` | `194.26x` |
|| [GraphQL JIT] | `1,112.24` | `89.38` | `9.82x` |
|| [async-graphql] | `1,077.74` | `92.31` | `9.52x` |
|| [Caliban] | `877.76` | `114.05` | `7.75x` |
|| [Gqlgen] | `395.24` | `249.77` | `3.49x` |
|| [Netflix DGS] | `184.47` | `537.50` | `1.63x` |
|| [Apollo GraphQL] | `131.00` | `701.19` | `1.16x` |
|| [Hasura] | `113.22` | `733.76` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `34,253.00` | `2.86` | `74.07x` |
|| [Caliban] | `5,378.17` | `18.68` | `11.63x` |
|| [async-graphql] | `5,320.64` | `18.79` | `11.51x` |
|| [GraphQL JIT] | `1,124.41` | `88.72` | `2.43x` |
|| [Gqlgen] | `1,102.79` | `100.02` | `2.38x` |
|| [Apollo GraphQL] | `891.87` | `112.56` | `1.93x` |
|| [Netflix DGS] | `806.84` | `154.83` | `1.74x` |
|| [Hasura] | `462.43` | `232.72` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `47,295.60` | `2.05` | `29.91x` |
|| [Tailcall] | `45,100.00` | `2.17` | `28.52x` |
|| [async-graphql] | `26,004.30` | `3.83` | `16.45x` |
|| [Gqlgen] | `25,936.10` | `4.97` | `16.40x` |
|| [GraphQL JIT] | `4,550.72` | `21.93` | `2.88x` |
|| [Netflix DGS] | `4,175.60` | `26.43` | `2.64x` |
|| [Apollo GraphQL] | `4,022.06` | `28.17` | `2.54x` |
|| [Hasura] | `1,581.07` | `63.07` | `1.00x` |

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
