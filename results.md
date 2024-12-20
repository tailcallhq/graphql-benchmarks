<!-- PERFORMANCE_RESULTS_START -->

| Query | Server | Requests/sec | Latency (ms) | Relative |
|-------:|--------:|--------------:|--------------:|---------:|
| 1 | `{ posts { id userId title user { id name email }}}` |
|| [Tailcall] | `21,537.70` | `4.64` | `195.88x` |
|| [GraphQL JIT] | `1,101.64` | `90.22` | `10.02x` |
|| [async-graphql] | `963.75` | `103.19` | `8.77x` |
|| [Caliban] | `779.22` | `128.80` | `7.09x` |
|| [Gqlgen] | `396.38` | `248.90` | `3.60x` |
|| [Netflix DGS] | `190.64` | `507.64` | `1.73x` |
|| [Apollo GraphQL] | `131.28` | `699.89` | `1.19x` |
|| [Hasura] | `109.95` | `851.67` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `32,698.20` | `3.06` | `71.94x` |
|| [async-graphql] | `5,142.55` | `19.51` | `11.31x` |
|| [Caliban] | `4,756.83` | `21.60` | `10.47x` |
|| [Gqlgen] | `1,132.18` | `96.72` | `2.49x` |
|| [GraphQL JIT] | `1,129.84` | `88.33` | `2.49x` |
|| [Apollo GraphQL] | `897.61` | `111.86` | `1.97x` |
|| [Netflix DGS] | `816.24` | `123.50` | `1.80x` |
|| [Hasura] | `454.50` | `239.19` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `40,272.70` | `2.48` | `26.56x` |
|| [Caliban] | `33,911.60` | `2.96` | `22.36x` |
|| [Gqlgen] | `24,155.90` | `9.51` | `15.93x` |
|| [async-graphql] | `23,969.90` | `4.20` | `15.81x` |
|| [GraphQL JIT] | `4,565.25` | `21.85` | `3.01x` |
|| [Netflix DGS] | `4,205.86` | `28.40` | `2.77x` |
|| [Apollo GraphQL] | `4,091.21` | `27.19` | `2.70x` |
|| [Hasura] | `1,516.39` | `66.15` | `1.00x` |

<!-- PERFORMANCE_RESULTS_END -->
