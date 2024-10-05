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
|| [Tailcall] | `12,327.80` | `8.07` | `134.38x` |
|| [GraphQL JIT] | `1,097.39` | `90.58` | `11.96x` |
|| [async-graphql] | `1,067.70` | `93.09` | `11.64x` |
|| [Caliban] | `887.80` | `113.28` | `9.68x` |
|| [Gqlgen] | `401.27` | `245.94` | `4.37x` |
|| [Netflix DGS] | `188.85` | `518.26` | `2.06x` |
|| [Apollo GraphQL] | `132.85` | `692.17` | `1.45x` |
|| [Hasura] | `91.74` | `686.70` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `20,501.50` | `4.85` | `51.54x` |
|| [Caliban] | `5,776.83` | `17.35` | `14.52x` |
|| [async-graphql] | `5,358.22` | `18.65` | `13.47x` |
|| [Gqlgen] | `1,124.01` | `98.17` | `2.83x` |
|| [GraphQL JIT] | `1,115.21` | `89.46` | `2.80x` |
|| [Apollo GraphQL] | `899.06` | `111.68` | `2.26x` |
|| [Netflix DGS] | `814.14` | `153.28` | `2.05x` |
|| [Hasura] | `397.75` | `261.78` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `46,283.30` | `2.10` | `30.05x` |
|| [async-graphql] | `25,615.10` | `3.89` | `16.63x` |
|| [Gqlgen] | `25,389.30` | `5.01` | `16.48x` |
|| [Tailcall] | `20,514.40` | `4.89` | `13.32x` |
|| [GraphQL JIT] | `4,457.94` | `22.37` | `2.89x` |
|| [Netflix DGS] | `4,186.94` | `27.01` | `2.72x` |
|| [Apollo GraphQL] | `4,039.38` | `28.61` | `2.62x` |
|| [Hasura] | `1,540.26` | `64.82` | `1.00x` |

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
