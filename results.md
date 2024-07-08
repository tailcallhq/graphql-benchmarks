<!-- PERFORMANCE_RESULTS_START -->

| Query | Server | Requests/sec | Latency (ms) | Relative |
|-------:|--------:|--------------:|--------------:|---------:|
| 1 | `{ posts { id userId title user { id name email }}}` |
|| [Tailcall] | `30,405.50` | `3.28` | `101.57x` |
|| [Caliban] | `1,580.37` | `63.27` | `5.28x` |
|| [async-graphql] | `1,520.98` | `65.65` | `5.08x` |
|| [Hasura] | `1,514.63` | `66.04` | `5.06x` |
|| [Gqlgen] | `664.10` | `151.20` | `2.22x` |
|| [Netflix DGS] | `363.90` | `222.57` | `1.22x` |
|| [Apollo GraphQL] | `299.35` | `332.23` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `62,263.70` | `1.59` | `38.98x` |
|| [Caliban] | `9,265.75` | `11.12` | `5.80x` |
|| [async-graphql] | `7,599.67` | `13.16` | `4.76x` |
|| [Hasura] | `2,561.55` | `38.96` | `1.60x` |
|| [Gqlgen] | `2,251.43` | `45.26` | `1.41x` |
|| [Apollo GraphQL] | `1,780.00` | `55.92` | `1.11x` |
|| [Netflix DGS] | `1,597.26` | `69.87` | `1.00x` |

<!-- PERFORMANCE_RESULTS_END -->
