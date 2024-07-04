<!-- PERFORMANCE_RESULTS_START -->

| Query | Server | Requests/sec | Latency (ms) | Relative |
|-------:|--------:|--------------:|--------------:|---------:|
| 1 | `{ posts { id userId title user { id name email }}}` |
|| [Tailcall] | `29,869.10` | `3.34` | `103.04x` |
|| [Caliban] | `1,590.34` | `62.88` | `5.49x` |
|| [async-graphql] | `1,474.68` | `67.71` | `5.09x` |
|| [Hasura] | `1,469.39` | `68.02` | `5.07x` |
|| [Gqlgen] | `641.60` | `156.36` | `2.21x` |
|| [Netflix DGS] | `362.26` | `178.54` | `1.25x` |
|| [Apollo GraphQL] | `289.88` | `342.62` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `61,933.50` | `1.61` | `38.96x` |
|| [Caliban] | `9,289.48` | `11.10` | `5.84x` |
|| [async-graphql] | `7,459.64` | `13.38` | `4.69x` |
|| [Hasura] | `2,490.59` | `40.18` | `1.57x` |
|| [Gqlgen] | `2,192.15` | `46.51` | `1.38x` |
|| [Apollo GraphQL] | `1,762.34` | `56.64` | `1.11x` |
|| [Netflix DGS] | `1,589.50` | `68.74` | `1.00x` |

<!-- PERFORMANCE_RESULTS_END -->
