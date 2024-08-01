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
|| [Tailcall] | `29,219.80` | `3.41` | `108.31x` |
|| [Hasura] | `4,936.49` | `20.45` | `18.30x` |
|| [async-graphql] | `1,988.54` | `50.62` | `7.37x` |
|| [Caliban] | `1,684.00` | `59.06` | `6.24x` |
|| [GraphQL JIT] | `1,370.16` | `72.66` | `5.08x` |
|| [Gqlgen] | `778.74` | `127.45` | `2.89x` |
|| [Netflix DGS] | `368.92` | `163.56` | `1.37x` |
|| [Apollo GraphQL] | `269.78` | `363.52` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `58,395.20` | `1.70` | `41.07x` |
|| [async-graphql] | `9,852.02` | `10.20` | `6.93x` |
|| [Caliban] | `9,575.60` | `10.81` | `6.73x` |
|| [Hasura] | `5,883.86` | `17.01` | `4.14x` |
|| [Gqlgen] | `2,172.62` | `47.71` | `1.53x` |
|| [Apollo GraphQL] | `1,762.94` | `56.68` | `1.24x` |
|| [Netflix DGS] | `1,606.32` | `69.98` | `1.13x` |
|| [GraphQL JIT] | `1,421.92` | `70.23` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `67,162.30` | `1.07` | `12.70x` |
|| [Tailcall] | `59,552.60` | `1.69` | `11.26x` |
|| [async-graphql] | `47,886.80` | `2.11` | `9.05x` |
|| [Gqlgen] | `46,928.50` | `5.18` | `8.87x` |
|| [Netflix DGS] | `8,220.21` | `14.91` | `1.55x` |
|| [Apollo GraphQL] | `7,852.13` | `12.94` | `1.48x` |
|| [Hasura] | `6,541.71` | `15.54` | `1.24x` |
|| [GraphQL JIT] | `5,289.75` | `18.88` | `1.00x` |

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
