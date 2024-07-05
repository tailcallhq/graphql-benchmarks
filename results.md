<!-- PERFORMANCE_RESULTS_START -->

| Query | Server | Requests/sec | Latency (ms) | Relative |
|-------:|--------:|--------------:|--------------:|---------:|
| 1 | `{ posts { id userId title user { id name email }}}` |
|| [Tailcall] | `30,484.10` | `3.27` | `102.08x` |
|| [Hasura] | `5,015.85` | `20.31` | `16.80x` |
|| [Caliban] | `1,604.02` | `62.37` | `5.37x` |
|| [async-graphql] | `1,514.64` | `65.91` | `5.07x` |
|| [Gqlgen] | `665.75` | `150.79` | `2.23x` |
|| [Netflix DGS] | `365.04` | `185.62` | `1.22x` |
|| [Apollo GraphQL] | `298.64` | `332.81` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `62,386.70` | `1.59` | `39.06x` |
|| [Caliban] | `9,215.30` | `11.21` | `5.77x` |
|| [async-graphql] | `7,476.39` | `13.38` | `4.68x` |
|| [Hasura] | `5,896.11` | `16.97` | `3.69x` |
|| [Gqlgen] | `2,257.70` | `45.12` | `1.41x` |
|| [Apollo GraphQL] | `1,779.18` | `55.96` | `1.11x` |
|| [Netflix DGS] | `1,597.16` | `68.58` | `1.00x` |

<!-- PERFORMANCE_RESULTS_END -->
