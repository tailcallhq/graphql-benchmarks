<!-- PERFORMANCE_RESULTS_START -->

| Query | Server | Requests/sec | Latency (ms) | Relative |
|-------:|--------:|--------------:|--------------:|---------:|
| 1 | `{ posts { id userId title user { id name email }}}` |
|| [Tailcall] | `30,719.90` | `3.24` | `106.64x` |
|| [Caliban] | `1,552.28` | `64.46` | `5.39x` |
|| [async-graphql] | `1,529.18` | `65.30` | `5.31x` |
|| [Hasura] | `1,526.69` | `65.44` | `5.30x` |
|| [Gqlgen] | `668.82` | `150.09` | `2.32x` |
|| [Netflix DGS] | `366.25` | `214.24` | `1.27x` |
|| [Apollo GraphQL] | `288.07` | `344.98` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `62,675.80` | `1.59` | `39.05x` |
|| [Caliban] | `9,376.31` | `11.01` | `5.84x` |
|| [async-graphql] | `7,642.62` | `13.09` | `4.76x` |
|| [Hasura] | `2,658.91` | `37.93` | `1.66x` |
|| [Gqlgen] | `2,280.64` | `44.69` | `1.42x` |
|| [Apollo GraphQL] | `1,763.63` | `56.54` | `1.10x` |
|| [Netflix DGS] | `1,604.82` | `67.96` | `1.00x` |

<!-- PERFORMANCE_RESULTS_END -->
