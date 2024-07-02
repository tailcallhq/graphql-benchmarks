<!-- PERFORMANCE_RESULTS_START -->

| Query | Server | Requests/sec | Latency (ms) | Relative |
|-------:|--------:|--------------:|--------------:|---------:|
| 1 | `{ posts { id userId title user { id name email }}}` |
|| [Tailcall] | `20,459.40` | `4.82` | `38.67x` |
|| [async-graphql] | `2,416.38` | `42.11` | `4.57x` |
|| [Caliban] | `2,112.29` | `51.58` | `3.99x` |
|| [Apollo GraphQL] | `2,013.53` | `49.98` | `3.81x` |
|| [Gqlgen] | `1,427.79` | `76.83` | `2.70x` |
|| [Netflix DGS] | `529.12` | `131.33` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `49,734.70` | `2.04` | `18.15x` |
|| [Caliban] | `13,721.40` | `11.63` | `5.01x` |
|| [async-graphql] | `9,333.76` | `11.00` | `3.41x` |
|| [Apollo GraphQL] | `4,299.68` | `25.27` | `1.57x` |
|| [Netflix DGS] | `2,778.82` | `70.96` | `1.01x` |
|| [Gqlgen] | `2,739.60` | `39.57` | `1.00x` |

<!-- PERFORMANCE_RESULTS_END -->
