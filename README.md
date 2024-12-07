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
|| [Tailcall] | `21,996.00` | `4.54` | `193.22x` |
|| [GraphQL JIT] | `1,081.08` | `91.89` | `9.50x` |
|| [async-graphql] | `1,001.51` | `99.12` | `8.80x` |
|| [Caliban] | `718.40` | `139.63` | `6.31x` |
|| [Gqlgen] | `396.74` | `248.54` | `3.49x` |
|| [Netflix DGS] | `188.83` | `514.79` | `1.66x` |
|| [Apollo GraphQL] | `128.30` | `711.52` | `1.13x` |
|| [Hasura] | `113.84` | `797.72` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `33,521.60` | `2.98` | `80.53x` |
|| [async-graphql] | `5,208.27` | `19.29` | `12.51x` |
|| [Caliban] | `4,777.52` | `21.39` | `11.48x` |
|| [Gqlgen] | `1,129.99` | `96.58` | `2.71x` |
|| [GraphQL JIT] | `1,112.37` | `89.69` | `2.67x` |
|| [Apollo GraphQL] | `886.37` | `113.13` | `2.13x` |
|| [Netflix DGS] | `811.71` | `124.26` | `1.95x` |
|| [Hasura] | `416.27` | `243.14` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `40,346.30` | `2.50` | `25.92x` |
|| [Caliban] | `34,135.60` | `2.96` | `21.93x` |
|| [Gqlgen] | `24,843.40` | `11.12` | `15.96x` |
|| [async-graphql] | `23,390.20` | `4.30` | `15.03x` |
|| [GraphQL JIT] | `4,526.47` | `22.05` | `2.91x` |
|| [Netflix DGS] | `4,232.35` | `28.14` | `2.72x` |
|| [Apollo GraphQL] | `4,058.22` | `27.11` | `2.61x` |
|| [Hasura] | `1,556.69` | `64.02` | `1.00x` |

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
