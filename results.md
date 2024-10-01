<!-- PERFORMANCE_RESULTS_START -->

| Query | Server | Requests/sec | Latency (ms) | Relative |
|-------:|--------:|--------------:|--------------:|---------:|
| 1 | `{ posts { id userId title user { id name email }}}` |
|| [GraphQL JIT] | `1,099.26` | `90.49` | `x` |
|| [async-graphql] | `1,028.25` | `96.69` | `x` |
|| [Caliban] | `848.62` | `118.21` | `x` |
|| [Gqlgen] | `390.58` | `252.32` | `x` |
|| [Netflix DGS] | `179.23` | `541.75` | `x` |
|| [Apollo GraphQL] | `132.56` | `694.98` | `x` |
|| [Hasura] | `112.09` | `802.07` | `x` |
|| [Tailcall] | `0.00` | `0.00` | `x` |
| 2 | `{ posts { title }}` |
|| [Caliban] | `5,507.02` | `18.20` | `x` |
|| [async-graphql] | `5,018.02` | `19.96` | `x` |
|| [GraphQL JIT] | `1,127.21` | `88.48` | `x` |
|| [Gqlgen] | `1,093.80` | `100.14` | `x` |
|| [Apollo GraphQL] | `887.42` | `113.22` | `x` |
|| [Netflix DGS] | `781.54` | `161.26` | `x` |
|| [Hasura] | `448.54` | `222.91` | `x` |
|| [Tailcall] | `0.00` | `0.00` | `x` |
| 3 | `{ greet }` |
|| [Caliban] | `46,451.10` | `2.09` | `x` |
|| [async-graphql] | `25,051.00` | `3.98` | `x` |
|| [Gqlgen] | `25,033.30` | `5.04` | `x` |
|| [GraphQL JIT] | `4,485.00` | `22.25` | `x` |
|| [Netflix DGS] | `4,084.67` | `28.21` | `x` |
|| [Apollo GraphQL] | `4,058.95` | `28.77` | `x` |
|| [Hasura] | `1,549.63` | `64.53` | `x` |
|| [Tailcall] | `0.00` | `0.00` | `x` |

<!-- PERFORMANCE_RESULTS_END -->
