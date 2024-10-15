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
|| [Tailcall] | `8,175.50` | `12.20` | `67.52x` |
|| [GraphQL JIT] | `1,128.48` | `88.07` | `9.32x` |
|| [async-graphql] | `1,008.02` | `98.67` | `8.33x` |
|| [Caliban] | `767.25` | `130.59` | `6.34x` |
|| [Gqlgen] | `366.30` | `269.01` | `3.03x` |
|| [Netflix DGS] | `181.45` | `531.58` | `1.50x` |
|| [Apollo GraphQL] | `129.91` | `703.91` | `1.07x` |
|| [Hasura] | `121.08` | `761.37` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `15,306.90` | `6.53` | `36.06x` |
|| [async-graphql] | `5,276.90` | `19.00` | `12.43x` |
|| [Caliban] | `4,944.19` | `20.69` | `11.65x` |
|| [GraphQL JIT] | `1,162.79` | `85.79` | `2.74x` |
|| [Gqlgen] | `1,070.78` | `101.96` | `2.52x` |
|| [Apollo GraphQL] | `874.51` | `114.87` | `2.06x` |
|| [Netflix DGS] | `790.90` | `126.65` | `1.86x` |
|| [Hasura] | `424.51` | `249.05` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `33,256.30` | `3.03` | `22.56x` |
|| [async-graphql] | `23,872.10` | `4.22` | `16.19x` |
|| [Gqlgen] | `23,438.60` | `10.17` | `15.90x` |
|| [Tailcall] | `20,580.70` | `4.88` | `13.96x` |
|| [GraphQL JIT] | `4,644.65` | `21.49` | `3.15x` |
|| [Netflix DGS] | `4,148.47` | `27.97` | `2.81x` |
|| [Apollo GraphQL] | `3,973.11` | `28.14` | `2.69x` |
|| [Hasura] | `1,474.44` | `68.46` | `1.00x` |

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
