<!-- PERFORMANCE_RESULTS_START -->

| Query | Server | Requests/sec | Latency (ms) | Relative |
|-------:|--------:|--------------:|--------------:|---------:|
| 1 | `{ posts { id userId title user { id name email }}}` |
|| [Tailcall] | `30,488.10` | `3.27` | `103.66x` |
|| [Caliban] | `1,600.20` | `62.42` | `5.44x` |
|| [async-graphql] | `1,491.59` | `66.96` | `5.07x` |
|| [Hasura] | `1,469.00` | `68.03` | `4.99x` |
|| [Gqlgen] | `663.75` | `151.37` | `2.26x` |
|| [Netflix DGS] | `365.81` | `139.47` | `1.24x` |
|| [Apollo GraphQL] | `294.12` | `337.76` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `62,175.10` | `1.60` | `38.75x` |
|| [Caliban] | `9,368.11` | `11.00` | `5.84x` |
|| [async-graphql] | `7,475.47` | `13.38` | `4.66x` |
|| [Hasura] | `2,437.26` | `40.96` | `1.52x` |
|| [Gqlgen] | `2,250.33` | `45.41` | `1.40x` |
|| [Apollo GraphQL] | `1,768.78` | `56.35` | `1.10x` |
|| [Netflix DGS] | `1,604.48` | `68.58` | `1.00x` |

<!-- PERFORMANCE_RESULTS_END -->
