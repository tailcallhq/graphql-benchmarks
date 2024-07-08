<!-- PERFORMANCE_RESULTS_START -->

| Query | Server | Requests/sec | Latency (ms) | Relative |
|-------:|--------:|--------------:|--------------:|---------:|
| 1 | `{ posts { id userId title user { id name email }}}` |
|| [Tailcall] | `30,731.30` | `3.24` | `108.23x` |
|| [async-graphql] | `1,748.25` | `57.58` | `6.16x` |
|| [Caliban] | `1,533.14` | `65.09` | `5.40x` |
|| [Hasura] | `1,528.73` | `65.21` | `5.38x` |
|| [Gqlgen] | `662.59` | `150.51` | `2.33x` |
|| [Netflix DGS] | `361.82` | `164.52` | `1.27x` |
|| [Apollo GraphQL] | `283.94` | `346.80` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `62,781.70` | `1.58` | `39.12x` |
|| [Caliban] | `9,206.32` | `11.23` | `5.74x` |
|| [async-graphql] | `8,679.90` | `11.56` | `5.41x` |
|| [Hasura] | `2,542.85` | `39.31` | `1.58x` |
|| [Gqlgen] | `2,270.77` | `45.08` | `1.42x` |
|| [Apollo GraphQL] | `1,790.88` | `55.76` | `1.12x` |
|| [Netflix DGS] | `1,604.71` | `68.88` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `65,204.50` | `1.55` | `25.47x` |
|| [Gqlgen] | `50,124.00` | `5.35` | `19.58x` |
|| [async-graphql] | `49,848.30` | `2.07` | `19.47x` |
|| [Caliban] | `46,625.10` | `2.47` | `18.21x` |
|| [Netflix DGS] | `8,306.34` | `14.78` | `3.24x` |
|| [Apollo GraphQL] | `8,131.77` | `12.50` | `3.18x` |
|| [Hasura] | `2,560.30` | `38.96` | `1.00x` |

<!-- PERFORMANCE_RESULTS_END -->
