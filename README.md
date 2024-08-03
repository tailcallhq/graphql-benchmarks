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
|| [Tailcall] | `28,176.20` | `3.54` | `209.64x` |
|| [async-graphql] | `1,939.27` | `51.54` | `14.43x` |
|| [Caliban] | `1,663.06` | `60.25` | `12.37x` |
|| [GraphQL JIT] | `1,347.65` | `73.89` | `10.03x` |
|| [Gqlgen] | `793.58` | `125.08` | `5.90x` |
|| [Netflix DGS] | `363.14` | `228.37` | `2.70x` |
|| [Apollo GraphQL] | `258.49` | `379.29` | `1.92x` |
|| [Hasura] | `134.40` | `511.26` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `57,079.00` | `1.75` | `70.94x` |
|| [async-graphql] | `9,672.12` | `10.40` | `12.02x` |
|| [Caliban] | `9,191.80` | `11.27` | `11.42x` |
|| [Gqlgen] | `2,208.57` | `46.88` | `2.75x` |
|| [Apollo GraphQL] | `1,682.62` | `59.36` | `2.09x` |
|| [Netflix DGS] | `1,594.24` | `70.61` | `1.98x` |
|| [GraphQL JIT] | `1,396.35` | `71.52` | `1.74x` |
|| [Hasura] | `804.57` | `124.03` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `67,796.50` | `1.16` | `26.38x` |
|| [Tailcall] | `58,735.50` | `1.71` | `22.86x` |
|| [async-graphql] | `48,290.90` | `2.12` | `18.79x` |
|| [Gqlgen] | `47,672.30` | `4.81` | `18.55x` |
|| [Netflix DGS] | `8,320.83` | `14.81` | `3.24x` |
|| [Apollo GraphQL] | `7,897.19` | `12.84` | `3.07x` |
|| [GraphQL JIT] | `5,182.66` | `19.27` | `2.02x` |
|| [Hasura] | `2,569.81` | `39.02` | `1.00x` |

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
