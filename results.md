<!-- PERFORMANCE_RESULTS_START -->

| Query | Server | Requests/sec | Latency (ms) | Relative |
|-------:|--------:|--------------:|--------------:|---------:|
| 1 | `{ posts { id userId title user { id name email }}}` |
|| [Tailcall] | `27,844.40` | `3.58` | `97.65x` |
|| [Caliban] | `1,570.63` | `63.65` | `5.51x` |
|| [async-graphql] | `1,521.41` | `65.63` | `5.34x` |
|| [Hasura] | `1,494.07` | `66.85` | `5.24x` |
|| [Gqlgen] | `635.46` | `158.03` | `2.23x` |
|| [Netflix DGS] | `363.59` | `188.54` | `1.28x` |
|| [Apollo GraphQL] | `285.15` | `348.56` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `60,541.40` | `1.64` | `38.28x` |
|| [Caliban] | `9,240.19` | `11.18` | `5.84x` |
|| [async-graphql] | `7,680.26` | `13.03` | `4.86x` |
|| [Hasura] | `2,552.54` | `39.21` | `1.61x` |
|| [Gqlgen] | `2,172.31` | `46.93` | `1.37x` |
|| [Apollo GraphQL] | `1,764.36` | `56.41` | `1.12x` |
|| [Netflix DGS] | `1,581.52` | `70.08` | `1.00x` |

<!-- PERFORMANCE_RESULTS_END -->
