<!-- PERFORMANCE_RESULTS_START -->

| Query | Server | Requests/sec | Latency (ms) | Relative |
|-------:|--------:|--------------:|--------------:|---------:|
| 1 | `{ posts { id userId title user { id name email }}}` |
|| [async-graphql] | `1,956.62` | `51.57` | `x` |
|| [Caliban] | `1,634.09` | `61.20` | `x` |
|| [GraphQL JIT] | `1,365.36` | `72.95` | `x` |
|| [Gqlgen] | `779.57` | `127.31` | `x` |
|| [Netflix DGS] | `367.16` | `168.01` | `x` |
|| [Apollo GraphQL] | `268.74` | `364.96` | `x` |
|| [Hasura] | `137.39` | `491.29` | `x` |
|| [Tailcall] | `0.00` | `0.00` | `x` |
| 2 | `{ posts { title }}` |
|| [async-graphql] | `9,700.37` | `10.36` | `x` |
|| [Caliban] | `9,475.48` | `10.94` | `x` |
|| [Gqlgen] | `2,174.18` | `47.62` | `x` |
|| [Apollo GraphQL] | `1,756.83` | `56.81` | `x` |
|| [Netflix DGS] | `1,604.55` | `69.72` | `x` |
|| [GraphQL JIT] | `1,409.16` | `70.85` | `x` |
|| [Hasura] | `867.37` | `115.02` | `x` |
|| [Tailcall] | `0.00` | `0.00` | `x` |
| 3 | `{ greet }` |
|| [Caliban] | `66,514.70` | `1.21` | `x` |
|| [async-graphql] | `47,499.50` | `2.17` | `x` |
|| [Gqlgen] | `47,346.70` | `4.99` | `x` |
|| [Netflix DGS] | `8,228.16` | `14.93` | `x` |
|| [Apollo GraphQL] | `8,095.76` | `12.65` | `x` |
|| [GraphQL JIT] | `5,213.44` | `19.15` | `x` |
|| [Hasura] | `2,642.63` | `37.76` | `x` |
|| [Tailcall] | `0.00` | `0.00` | `x` |

<!-- PERFORMANCE_RESULTS_END -->
