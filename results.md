<!-- PERFORMANCE_RESULTS_START -->

| Query | Server | Requests/sec | Latency (ms) | Relative |
|-------:|--------:|--------------:|--------------:|---------:|
| 1 | `{ posts { id userId title user { id name email }}}` |
|| [Tailcall] | `29,831.60` | `3.34` | `105.62x` |
|| [Hasura] | `4,705.30` | `21.25` | `16.66x` |
|| [Caliban] | `1,563.16` | `63.89` | `5.53x` |
|| [async-graphql] | `1,506.08` | `66.29` | `5.33x` |
|| [Gqlgen] | `658.01` | `152.62` | `2.33x` |
|| [Netflix DGS] | `360.71` | `218.65` | `1.28x` |
|| [Apollo GraphQL] | `282.43` | `351.32` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `61,434.00` | `1.62` | `39.05x` |
|| [Caliban] | `9,102.14` | `11.35` | `5.79x` |
|| [async-graphql] | `7,381.66` | `13.55` | `4.69x` |
|| [Hasura] | `5,824.85` | `17.14` | `3.70x` |
|| [Gqlgen] | `2,227.86` | `45.75` | `1.42x` |
|| [Apollo GraphQL] | `1,674.88` | `59.41` | `1.06x` |
|| [Netflix DGS] | `1,573.25` | `69.44` | `1.00x` |

<!-- PERFORMANCE_RESULTS_END -->
