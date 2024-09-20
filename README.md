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
|| [Tailcall] | `20,315.10` | `4.85` | `173.20x` |
|| [GraphQL JIT] | `1,133.47` | `87.76` | `9.66x` |
|| [async-graphql] | `940.39` | `105.77` | `8.02x` |
|| [Caliban] | `821.72` | `122.02` | `7.01x` |
|| [Gqlgen] | `408.74` | `241.37` | `3.48x` |
|| [Netflix DGS] | `185.92` | `533.09` | `1.59x` |
|| [Apollo GraphQL] | `127.18` | `716.77` | `1.08x` |
|| [Hasura] | `117.29` | `699.65` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `33,131.80` | `2.96` | `74.02x` |
|| [Caliban] | `5,247.26` | `19.16` | `11.72x` |
|| [async-graphql] | `5,044.62` | `19.86` | `11.27x` |
|| [GraphQL JIT] | `1,174.37` | `84.98` | `2.62x` |
|| [Gqlgen] | `1,131.29` | `97.45` | `2.53x` |
|| [Apollo GraphQL] | `865.31` | `116.17` | `1.93x` |
|| [Netflix DGS] | `806.45` | `158.62` | `1.80x` |
|| [Hasura] | `447.62` | `224.84` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `46,014.30` | `2.10` | `30.69x` |
|| [Tailcall] | `26,269.00` | `3.79` | `17.52x` |
|| [async-graphql] | `25,304.00` | `3.94` | `16.88x` |
|| [Gqlgen] | `24,976.70` | `5.13` | `16.66x` |
|| [GraphQL JIT] | `4,547.90` | `21.94` | `3.03x` |
|| [Netflix DGS] | `4,163.81` | `28.09` | `2.78x` |
|| [Apollo GraphQL] | `3,853.69` | `30.48` | `2.57x` |
|| [Hasura] | `1,499.30` | `67.07` | `1.00x` |

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
