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
|| [Tailcall] | `21,546.00` | `4.63` | `180.34x` |
|| [GraphQL JIT] | `1,088.97` | `91.37` | `9.11x` |
|| [async-graphql] | `980.99` | `101.22` | `8.21x` |
|| [Caliban] | `776.21` | `129.42` | `6.50x` |
|| [Gqlgen] | `365.65` | `269.11` | `3.06x` |
|| [Netflix DGS] | `186.40` | `520.46` | `1.56x` |
|| [Apollo GraphQL] | `133.91` | `689.17` | `1.12x` |
|| [Hasura] | `119.48` | `756.82` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `32,527.80` | `3.07` | `77.15x` |
|| [async-graphql] | `5,159.85` | `19.38` | `12.24x` |
|| [Caliban] | `4,824.27` | `21.24` | `11.44x` |
|| [GraphQL JIT] | `1,122.51` | `88.90` | `2.66x` |
|| [Gqlgen] | `1,080.97` | `101.16` | `2.56x` |
|| [Apollo GraphQL] | `895.35` | `112.08` | `2.12x` |
|| [Netflix DGS] | `813.59` | `123.37` | `1.93x` |
|| [Hasura] | `421.60` | `241.07` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `39,511.60` | `2.53` | `24.37x` |
|| [Caliban] | `33,703.00` | `2.98` | `20.79x` |
|| [async-graphql] | `23,823.90` | `4.21` | `14.70x` |
|| [Gqlgen] | `23,724.30` | `10.27` | `14.64x` |
|| [GraphQL JIT] | `4,542.98` | `21.97` | `2.80x` |
|| [Netflix DGS] | `4,182.61` | `27.96` | `2.58x` |
|| [Apollo GraphQL] | `4,095.63` | `27.52` | `2.53x` |
|| [Hasura] | `1,621.00` | `64.73` | `1.00x` |

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
