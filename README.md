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
|| [Tailcall] | `19,449.30` | `5.07` | `169.46x` |
|| [GraphQL JIT] | `1,157.61` | `85.95` | `10.09x` |
|| [async-graphql] | `1,045.41` | `95.06` | `9.11x` |
|| [Caliban] | `828.03` | `121.20` | `7.21x` |
|| [Gqlgen] | `394.35` | `250.13` | `3.44x` |
|| [Netflix DGS] | `184.47` | `528.40` | `1.61x` |
|| [Apollo GraphQL] | `131.83` | `697.24` | `1.15x` |
|| [Hasura] | `114.77` | `743.41` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `31,829.70` | `3.09` | `77.56x` |
|| [Caliban] | `5,350.28` | `18.74` | `13.04x` |
|| [async-graphql] | `5,212.00` | `19.18` | `12.70x` |
|| [GraphQL JIT] | `1,200.70` | `83.13` | `2.93x` |
|| [Gqlgen] | `1,099.24` | `99.77` | `2.68x` |
|| [Apollo GraphQL] | `895.06` | `112.24` | `2.18x` |
|| [Netflix DGS] | `812.13` | `151.61` | `1.98x` |
|| [Hasura] | `410.40` | `243.93` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `48,026.40` | `2.01` | `30.75x` |
|| [Gqlgen] | `25,494.80` | `5.06` | `16.32x` |
|| [async-graphql] | `25,264.50` | `3.94` | `16.17x` |
|| [Tailcall] | `24,398.80` | `4.08` | `15.62x` |
|| [GraphQL JIT] | `4,723.97` | `21.13` | `3.02x` |
|| [Netflix DGS] | `4,160.74` | `26.26` | `2.66x` |
|| [Apollo GraphQL] | `4,044.06` | `28.29` | `2.59x` |
|| [Hasura] | `1,561.98` | `63.74` | `1.00x` |

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
