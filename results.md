<!-- PERFORMANCE_RESULTS_START -->

| Query | Server | Requests/sec | Latency (ms) | Relative |
|-------:|--------:|--------------:|--------------:|---------:|
| 1 | `{ posts { id userId title user { id name email }}}` |
|| [Tailcall] | `29,534.90` | `3.37` | `102.64x` |
|| [Hasura] | `4,601.66` | `21.71` | `15.99x` |
|| [Caliban] | `1,574.63` | `63.42` | `5.47x` |
|| [async-graphql] | `1,457.27` | `68.51` | `5.06x` |
|| [Gqlgen] | `641.88` | `156.54` | `2.23x` |
|| [Netflix DGS] | `362.21` | `150.25` | `1.26x` |
|| [Apollo GraphQL] | `287.75` | `345.31` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `61,457.60` | `1.62` | `38.92x` |
|| [Caliban] | `9,243.21` | `11.19` | `5.85x` |
|| [async-graphql] | `7,321.85` | `13.66` | `4.64x` |
|| [Hasura] | `5,648.75` | `17.70` | `3.58x` |
|| [Gqlgen] | `2,196.22` | `46.47` | `1.39x` |
|| [Apollo GraphQL] | `1,735.65` | `57.40` | `1.10x` |
|| [Netflix DGS] | `1,579.14` | `69.21` | `1.00x` |

<!-- PERFORMANCE_RESULTS_END -->
