<!-- PERFORMANCE_RESULTS_START -->

| Query | Server | Requests/sec | Latency (ms) | Relative |
|-------:|--------:|--------------:|--------------:|---------:|
| 1 | `{ posts { id userId title user { id name email }}}` |
|| [Tailcall] | `27,555.80` | `3.61` | `105.99x` |
|| [async-graphql] | `1,614.09` | `62.05` | `6.21x` |
|| [Caliban] | `1,515.67` | `65.59` | `5.83x` |
|| [Hasura] | `1,285.42` | `78.55` | `4.94x` |
|| [Gqlgen] | `614.70` | `162.08` | `2.36x` |
|| [Netflix DGS] | `351.78` | `209.52` | `1.35x` |
|| [Apollo GraphQL] | `259.99` | `378.04` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `57,898.80` | `1.72` | `36.99x` |
|| [Caliban] | `9,219.19` | `11.21` | `5.89x` |
|| [async-graphql] | `8,319.61` | `12.03` | `5.32x` |
|| [Hasura] | `2,181.93` | `45.80` | `1.39x` |
|| [Gqlgen] | `2,118.07` | `48.44` | `1.35x` |
|| [Apollo GraphQL] | `1,626.41` | `61.40` | `1.04x` |
|| [Netflix DGS] | `1,565.25` | `70.23` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `62,556.00` | `1.61` | `26.32x` |
|| [async-graphql] | `49,131.90` | `2.07` | `20.67x` |
|| [Gqlgen] | `46,347.60` | `5.74` | `19.50x` |
|| [Caliban] | `45,176.40` | `2.56` | `19.01x` |
|| [Netflix DGS] | `8,087.36` | `14.76` | `3.40x` |
|| [Apollo GraphQL] | `7,765.66` | `13.15` | `3.27x` |
|| [Hasura] | `2,376.95` | `42.02` | `1.00x` |

<!-- PERFORMANCE_RESULTS_END -->
