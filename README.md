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
|| [Tailcall] | `28,499.50` | `3.49` | `229.28x` |
|| [async-graphql] | `1,999.93` | `50.08` | `16.09x` |
|| [Caliban] | `1,755.97` | `57.16` | `14.13x` |
|| [GraphQL JIT] | `1,306.76` | `76.22` | `10.51x` |
|| [Gqlgen] | `749.01` | `132.49` | `6.03x` |
|| [Netflix DGS] | `366.10` | `175.62` | `2.95x` |
|| [Apollo GraphQL] | `269.02` | `364.25` | `2.16x` |
|| [Hasura] | `124.30` | `541.10` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `57,322.20` | `1.74` | `67.49x` |
|| [async-graphql] | `10,002.10` | `10.28` | `11.78x` |
|| [Caliban] | `9,903.98` | `10.43` | `11.66x` |
|| [Gqlgen] | `2,110.79` | `49.15` | `2.49x` |
|| [Apollo GraphQL] | `1,734.84` | `57.55` | `2.04x` |
|| [Netflix DGS] | `1,605.63` | `70.22` | `1.89x` |
|| [GraphQL JIT] | `1,364.46` | `73.18` | `1.61x` |
|| [Hasura] | `849.40` | `117.47` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `68,493.80` | `1.05` | `26.61x` |
|| [Tailcall] | `58,603.10` | `1.72` | `22.76x` |
|| [async-graphql] | `47,472.30` | `2.19` | `18.44x` |
|| [Gqlgen] | `45,436.10` | `5.17` | `17.65x` |
|| [Netflix DGS] | `8,312.41` | `14.48` | `3.23x` |
|| [Apollo GraphQL] | `8,111.71` | `12.54` | `3.15x` |
|| [GraphQL JIT] | `5,193.43` | `19.23` | `2.02x` |
|| [Hasura] | `2,574.40` | `38.77` | `1.00x` |

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
