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
|| [Tailcall] | `21,691.00` | `4.60` | `204.33x` |
|| [async-graphql] | `10,456.50` | `9.64` | `98.50x` |
|| [Caliban] | `7,379.32` | `13.52` | `69.51x` |
|| [GraphQL JIT] | `1,082.98` | `91.82` | `10.20x` |
|| [Gqlgen] | `390.46` | `252.36` | `3.68x` |
|| [Netflix DGS] | `186.27` | `518.00` | `1.75x` |
|| [Apollo GraphQL] | `127.32` | `716.59` | `1.20x` |
|| [Hasura] | `106.16` | `843.28` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [async-graphql] | `59,383.60` | `1.78` | `135.03x` |
|| [Caliban] | `45,511.20` | `2.27` | `103.49x` |
|| [Tailcall] | `33,203.40` | `3.01` | `75.50x` |
|| [GraphQL JIT] | `1,127.72` | `88.51` | `2.56x` |
|| [Gqlgen] | `1,120.66` | `98.00` | `2.55x` |
|| [Apollo GraphQL] | `869.68` | `115.43` | `1.98x` |
|| [Netflix DGS] | `800.13` | `125.35` | `1.82x` |
|| [Hasura] | `439.77` | `234.24` | `1.00x` |
| 3 | `{ greet }` |
|| [async-graphql] | `435,675.00` | `226.08` | `294.10x` |
|| [Caliban] | `324,524.00` | `349.96` | `219.07x` |
|| [Tailcall] | `39,880.30` | `2.51` | `26.92x` |
|| [Gqlgen] | `24,406.20` | `8.77` | `16.48x` |
|| [GraphQL JIT] | `4,468.64` | `22.30` | `3.02x` |
|| [Netflix DGS] | `4,204.98` | `28.05` | `2.84x` |
|| [Apollo GraphQL] | `3,989.34` | `27.64` | `2.69x` |
|| [Hasura] | `1,481.37` | `67.33` | `1.00x` |

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
