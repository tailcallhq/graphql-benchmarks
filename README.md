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
|| [Tailcall] | `20,092.70` | `4.96` | `165.55x` |
|| [GraphQL JIT] | `1,074.57` | `92.56` | `8.85x` |
|| [async-graphql] | `1,006.45` | `98.64` | `8.29x` |
|| [Caliban] | `781.56` | `128.55` | `6.44x` |
|| [Gqlgen] | `366.00` | `269.29` | `3.02x` |
|| [Netflix DGS] | `178.29` | `545.29` | `1.47x` |
|| [Apollo GraphQL] | `122.45` | `738.55` | `1.01x` |
|| [Hasura] | `121.37` | `749.25` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `31,845.50` | `3.14` | `74.19x` |
|| [async-graphql] | `4,979.60` | `20.12` | `11.60x` |
|| [Caliban] | `4,748.97` | `21.68` | `11.06x` |
|| [GraphQL JIT] | `1,080.00` | `92.39` | `2.52x` |
|| [Gqlgen] | `1,065.04` | `103.41` | `2.48x` |
|| [Apollo GraphQL] | `849.98` | `118.20` | `1.98x` |
|| [Netflix DGS] | `775.16` | `130.31` | `1.81x` |
|| [Hasura] | `429.24` | `231.96` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `38,122.90` | `2.63` | `26.09x` |
|| [Caliban] | `32,972.80` | `3.04` | `22.57x` |
|| [async-graphql] | `23,258.30` | `4.32` | `15.92x` |
|| [Gqlgen] | `23,148.60` | `8.71` | `15.85x` |
|| [GraphQL JIT] | `4,412.80` | `22.60` | `3.02x` |
|| [Netflix DGS] | `4,068.49` | `28.98` | `2.78x` |
|| [Apollo GraphQL] | `3,889.77` | `28.33` | `2.66x` |
|| [Hasura] | `1,460.94` | `68.40` | `1.00x` |

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
