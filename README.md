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
|| [Tailcall] | `76,805.20` | `1.25` | `673.51x` |
|| [Netflix DGS] | `1,422.59` | `46.03` | `12.47x` |
|| [GraphQL JIT] | `1,122.34` | `88.58` | `9.84x` |
|| [async-graphql] | `1,000.51` | `99.34` | `8.77x` |
|| [Caliban] | `777.69` | `128.06` | `6.82x` |
|| [Gqlgen] | `398.26` | `247.47` | `3.49x` |
|| [Apollo GraphQL] | `115.11` | `778.66` | `1.01x` |
|| [Hasura] | `114.04` | `824.42` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `167,238.00` | `559.96` | `368.97x` |
|| [Netflix DGS] | `7,864.90` | `15.35` | `17.35x` |
|| [async-graphql] | `5,213.96` | `19.17` | `11.50x` |
|| [Caliban] | `4,634.00` | `22.14` | `10.22x` |
|| [GraphQL JIT] | `1,154.26` | `86.46` | `2.55x` |
|| [Gqlgen] | `1,127.48` | `97.28` | `2.49x` |
|| [Apollo GraphQL] | `827.02` | `121.45` | `1.82x` |
|| [Hasura] | `453.26` | `222.97` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `358,722.00` | `270.90` | `234.64x` |
|| [Caliban] | `32,795.40` | `3.07` | `21.45x` |
|| [Netflix DGS] | `28,250.50` | `3.66` | `18.48x` |
|| [Gqlgen] | `24,521.10` | `8.90` | `16.04x` |
|| [async-graphql] | `23,956.10` | `4.22` | `15.67x` |
|| [GraphQL JIT] | `4,633.23` | `21.54` | `3.03x` |
|| [Apollo GraphQL] | `3,941.17` | `27.79` | `2.58x` |
|| [Hasura] | `1,528.85` | `65.59` | `1.00x` |

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
