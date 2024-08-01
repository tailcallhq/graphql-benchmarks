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
|| [Tailcall] | `29,453.00` | `3.38` | `318.48x` |
|| [async-graphql] | `2,040.67` | `50.29` | `22.07x` |
|| [Caliban] | `1,731.75` | `57.47` | `18.73x` |
|| [GraphQL JIT] | `1,355.98` | `73.42` | `14.66x` |
|| [Gqlgen] | `813.38` | `122.01` | `8.80x` |
|| [Netflix DGS] | `363.50` | `140.77` | `3.93x` |
|| [Apollo GraphQL] | `276.50` | `355.02` | `2.99x` |
|| [Hasura] | `92.48` | `553.60` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `58,606.60` | `1.70` | `69.03x` |
|| [async-graphql] | `9,959.56` | `10.39` | `11.73x` |
|| [Caliban] | `9,564.63` | `10.81` | `11.27x` |
|| [Gqlgen] | `2,230.35` | `46.44` | `2.63x` |
|| [Apollo GraphQL] | `1,784.84` | `55.96` | `2.10x` |
|| [Netflix DGS] | `1,595.96` | `70.85` | `1.88x` |
|| [GraphQL JIT] | `1,412.86` | `70.68` | `1.66x` |
|| [Hasura] | `848.94` | `117.58` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `68,952.90` | `1.04` | `26.22x` |
|| [Tailcall] | `60,016.40` | `1.68` | `22.82x` |
|| [Gqlgen] | `48,289.20` | `4.95` | `18.36x` |
|| [async-graphql] | `47,552.20` | `2.24` | `18.08x` |
|| [Netflix DGS] | `8,191.41` | `15.21` | `3.11x` |
|| [Apollo GraphQL] | `8,118.25` | `12.45` | `3.09x` |
|| [GraphQL JIT] | `5,254.44` | `19.00` | `2.00x` |
|| [Hasura] | `2,629.94` | `38.03` | `1.00x` |

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
