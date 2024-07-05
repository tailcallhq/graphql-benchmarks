<!-- PERFORMANCE_RESULTS_START -->

| Query | Server | Requests/sec | Latency (ms) | Relative |
|-------:|--------:|--------------:|--------------:|---------:|
| 1 | `{ posts { id userId title user { id name email }}}` |
|| [Tailcall] | `27,278.70` | `3.65` | `96.32x` |
|| [Caliban] | `1,538.96` | `64.91` | `5.43x` |
|| [Hasura] | `1,456.97` | `68.60` | `5.14x` |
|| [async-graphql] | `1,405.04` | `71.07` | `4.96x` |
|| [Gqlgen] | `621.80` | `161.41` | `2.20x` |
|| [Netflix DGS] | `356.98` | `196.94` | `1.26x` |
|| [Apollo GraphQL] | `283.20` | `350.80` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `59,472.10` | `1.67` | `37.94x` |
|| [Caliban] | `9,247.14` | `11.12` | `5.90x` |
|| [async-graphql] | `7,338.15` | `13.63` | `4.68x` |
|| [Hasura] | `2,415.54` | `41.32` | `1.54x` |
|| [Gqlgen] | `2,143.39` | `47.64` | `1.37x` |
|| [Apollo GraphQL] | `1,681.53` | `59.20` | `1.07x` |
|| [Netflix DGS] | `1,567.36` | `69.99` | `1.00x` |

<!-- PERFORMANCE_RESULTS_END -->
