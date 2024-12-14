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
|| [Tailcall] | `21,210.90` | `4.71` | `187.40x` |
|| [GraphQL JIT] | `2,351.92` | `42.42` | `20.78x` |
|| [Gqlgen] | `1,773.10` | `56.24` | `15.67x` |
|| [async-graphql] | `984.45` | `100.82` | `8.70x` |
|| [Caliban] | `790.73` | `126.49` | `6.99x` |
|| [Netflix DGS] | `190.50` | `511.85` | `1.68x` |
|| [Apollo GraphQL] | `132.66` | `694.65` | `1.17x` |
|| [Hasura] | `113.19` | `802.94` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `33,227.00` | `3.01` | `81.91x` |
|| [Gqlgen] | `7,055.44` | `15.71` | `17.39x` |
|| [async-graphql] | `5,171.06` | `19.56` | `12.75x` |
|| [Caliban] | `4,826.40` | `21.18` | `11.90x` |
|| [GraphQL JIT] | `2,437.37` | `41.01` | `6.01x` |
|| [Apollo GraphQL] | `896.45` | `111.95` | `2.21x` |
|| [Netflix DGS] | `814.32` | `124.15` | `2.01x` |
|| [Hasura] | `405.63` | `259.41` | `1.00x` |
| 3 | `{ greet }` |
|| [Gqlgen] | `168,619.00` | `793.06` | `113.39x` |
|| [Tailcall] | `40,240.10` | `2.49` | `27.06x` |
|| [Caliban] | `33,686.70` | `2.97` | `22.65x` |
|| [async-graphql] | `23,548.70` | `4.27` | `15.84x` |
|| [GraphQL JIT] | `9,788.25` | `10.19` | `6.58x` |
|| [Netflix DGS] | `4,201.95` | `29.05` | `2.83x` |
|| [Apollo GraphQL] | `4,090.74` | `26.90` | `2.75x` |
|| [Hasura] | `1,487.11` | `67.41` | `1.00x` |

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
