<!-- PERFORMANCE_RESULTS_START -->

| Query | Server | Requests/sec | Latency (ms) | Relative |
|-------:|--------:|--------------:|--------------:|---------:|
| 1 | `{ posts { id userId title user { id name email }}}` |
|| [GraphQL JIT] | `1,098.29` | `90.60` | `x` |
|| [async-graphql] | `1,089.92` | `91.30` | `x` |
|| [Caliban] | `835.38` | `120.53` | `x` |
|| [Gqlgen] | `401.31` | `245.94` | `x` |
|| [Netflix DGS] | `186.66` | `523.36` | `x` |
|| [Apollo GraphQL] | `133.72` | `689.38` | `x` |
|| [Hasura] | `109.60` | `801.34` | `x` |
|| [Tailcall] | `0.00` | `0.00` | `x` |
| 2 | `{ posts { title }}` |
|| [Caliban] | `5,680.64` | `17.66` | `x` |
|| [async-graphql] | `5,396.03` | `18.52` | `x` |
|| [GraphQL JIT] | `1,152.31` | `86.57` | `x` |
|| [Gqlgen] | `1,100.58` | `100.14` | `x` |
|| [Apollo GraphQL] | `901.67` | `111.40` | `x` |
|| [Netflix DGS] | `804.93` | `160.00` | `x` |
|| [Hasura] | `459.05` | `220.07` | `x` |
|| [Tailcall] | `0.00` | `0.00` | `x` |
| 3 | `{ greet }` |
|| [Caliban] | `47,153.70` | `2.06` | `x` |
|| [async-graphql] | `25,476.80` | `3.91` | `x` |
|| [Gqlgen] | `25,044.80` | `5.13` | `x` |
|| [GraphQL JIT] | `4,518.34` | `22.08` | `x` |
|| [Netflix DGS] | `4,113.32` | `27.96` | `x` |
|| [Apollo GraphQL] | `4,078.04` | `28.41` | `x` |
|| [Hasura] | `1,540.52` | `66.46` | `x` |
|| [Tailcall] | `0.00` | `0.00` | `x` |

<!-- PERFORMANCE_RESULTS_END -->
