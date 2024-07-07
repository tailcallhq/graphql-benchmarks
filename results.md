<!-- PERFORMANCE_RESULTS_START -->

| Query | Server | Requests/sec | Latency (ms) | Relative |
|-------:|--------:|--------------:|--------------:|---------:|
| 1 | `{ posts { id userId title user { id name email }}}` |
|| [Tailcall] | `28,997.20` | `3.44` | `100.15x` |
|| [Caliban] | `1,568.12` | `63.70` | `5.42x` |
|| [Hasura] | `1,483.00` | `67.45` | `5.12x` |
|| [async-graphql] | `1,477.59` | `67.57` | `5.10x` |
|| [Gqlgen] | `646.99` | `155.15` | `2.23x` |
|| [Netflix DGS] | `363.69` | `171.74` | `1.26x` |
|| [Apollo GraphQL] | `289.53` | `342.97` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `60,936.50` | `1.62` | `38.65x` |
|| [Caliban] | `9,228.20` | `11.16` | `5.85x` |
|| [async-graphql] | `7,572.85` | `13.21` | `4.80x` |
|| [Hasura] | `2,470.17` | `40.48` | `1.57x` |
|| [Gqlgen] | `2,199.03` | `46.44` | `1.39x` |
|| [Apollo GraphQL] | `1,741.80` | `57.24` | `1.10x` |
|| [Netflix DGS] | `1,576.48` | `69.21` | `1.00x` |

<!-- PERFORMANCE_RESULTS_END -->
