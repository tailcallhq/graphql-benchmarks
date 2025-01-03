<!-- PERFORMANCE_RESULTS_START -->

| Query | Server | Requests/sec | Latency (ms) | Relative |
|-------:|--------:|--------------:|--------------:|---------:|
| 1 | `{ posts { id userId title user { id name email }}}` |
|| [Tailcall] | `20,054.40` | `4.98` | `176.72x` |
|| [GraphQL JIT] | `1,099.14` | `90.51` | `9.69x` |
|| [async-graphql] | `993.38` | `99.94` | `8.75x` |
|| [Caliban] | `763.65` | `131.16` | `6.73x` |
|| [Gqlgen] | `403.07` | `244.63` | `3.55x` |
|| [Netflix DGS] | `187.50` | `515.61` | `1.65x` |
|| [Apollo GraphQL] | `132.85` | `691.19` | `1.17x` |
|| [Hasura] | `113.48` | `815.83` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `32,400.00` | `3.08` | `78.62x` |
|| [async-graphql] | `5,036.85` | `19.87` | `12.22x` |
|| [Caliban] | `4,698.14` | `21.77` | `11.40x` |
|| [GraphQL JIT] | `1,132.61` | `88.09` | `2.75x` |
|| [Gqlgen] | `1,101.66` | `99.29` | `2.67x` |
|| [Apollo GraphQL] | `901.94` | `111.29` | `2.19x` |
|| [Netflix DGS] | `803.86` | `125.09` | `1.95x` |
|| [Hasura] | `412.12` | `246.38` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `38,985.10` | `2.58` | `24.45x` |
|| [Caliban] | `33,689.50` | `2.99` | `21.13x` |
|| [Gqlgen] | `24,871.80` | `11.49` | `15.60x` |
|| [async-graphql] | `23,797.00` | `4.21` | `14.92x` |
|| [GraphQL JIT] | `4,548.05` | `21.94` | `2.85x` |
|| [Netflix DGS] | `4,119.12` | `29.21` | `2.58x` |
|| [Apollo GraphQL] | `4,048.34` | `26.56` | `2.54x` |
|| [Hasura] | `1,594.69` | `66.89` | `1.00x` |

<!-- PERFORMANCE_RESULTS_END -->
