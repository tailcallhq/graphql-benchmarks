<!-- PERFORMANCE_RESULTS_START -->

| Query | Server | Requests/sec | Latency (ms) | Relative |
|-------:|--------:|--------------:|--------------:|---------:|
| 1 | `{ posts { id userId title user { id name email }}}` |
|| [Tailcall] | `30,158.70` | `3.30` | `105.66x` |
|| [async-graphql] | `1,688.26` | `60.72` | `5.91x` |
|| [Caliban] | `1,561.81` | `63.68` | `5.47x` |
|| [Hasura] | `1,472.13` | `67.66` | `5.16x` |
|| [Gqlgen] | `657.40` | `151.89` | `2.30x` |
|| [Netflix DGS] | `363.69` | `162.42` | `1.27x` |
|| [Apollo GraphQL] | `285.43` | `345.82` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `62,409.00` | `1.59` | `38.75x` |
|| [Caliban] | `9,274.35` | `11.13` | `5.76x` |
|| [async-graphql] | `8,615.45` | `11.69` | `5.35x` |
|| [Hasura] | `2,457.92` | `40.64` | `1.53x` |
|| [Gqlgen] | `2,260.61` | `45.46` | `1.40x` |
|| [Apollo GraphQL] | `1,787.09` | `55.89` | `1.11x` |
|| [Netflix DGS] | `1,610.50` | `68.66` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `64,615.20` | `1.56` | `26.64x` |
|| [async-graphql] | `49,507.70` | `2.11` | `20.41x` |
|| [Gqlgen] | `49,100.80` | `6.01` | `20.25x` |
|| [Caliban] | `47,567.30` | `2.34` | `19.61x` |
|| [Netflix DGS] | `8,298.97` | `14.50` | `3.42x` |
|| [Apollo GraphQL] | `8,090.79` | `12.59` | `3.34x` |
|| [Hasura] | `2,425.21` | `41.17` | `1.00x` |

<!-- PERFORMANCE_RESULTS_END -->
