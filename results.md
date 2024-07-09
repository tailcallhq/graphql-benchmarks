

Query: `
    {
      "operationName": null,
      "variables": {},
      "query": "{posts{id,userId,title,user{id,name,email}}}"
    }
    `

| Server         | Requests/sec | Latency (ms) | Relative |
| -------------- | ------------ | ------------ | -------- |
| Tailcall       | `88,929.36`  | `1.12`       | `40.28x` |
| Netflix DGS    | `56,996.51`  | `0.00`       | `25.82x` |
| Apollo GraphQL | `52,527.60`  | `0.00`       | `23.79x` |
| async-graphql  | `35,682.22`  | `2.84`       | `16.16x` |
| Gqlgen         | `35,393.13`  | `2.82`       | `16.03x` |
| Caliban        | `25,941.48`  | `4.00`       | `11.75x` |
| Hasura         | `2,207.78`   | `45.56`      | `1.00x`  |

Query: `
    {
      "operationName": null,
      "variables": {},
      "query": "{posts{title}}"
    }
    `

| Server         | Requests/sec | Latency (ms) | Relative |
| -------------- | ------------ | ------------ | -------- |
| Tailcall       | `92,106.42`  | `1.08`       | `31.47x` |
| Apollo GraphQL | `55,214.49`  | `0.00`       | `18.87x` |
| Netflix DGS    | `54,845.37`  | `0.00`       | `18.74x` |
| async-graphql  | `38,675.54`  | `2.58`       | `13.21x` |
| Gqlgen         | `32,393.30`  | `3.09`       | `11.07x` |
| Caliban        | `31,239.34`  | `3.20`       | `10.67x` |
| Hasura         | `2,926.73`   | `34.22`      | `1.00x`  |

Query: `
    {
      "operationName": null,
      "variables": {},
      "query": "{greet}"
    }
    `

| Server         | Requests/sec | Latency (ms) | Relative |
| -------------- | ------------ | ------------ | -------- |
| async-graphql  | `114,666.64` | `0.87`       | `26.12x` |
| Tailcall       | `106,999.46` | `0.93`       | `24.37x` |
| Caliban        | `97,864.89`  | `1.01`       | `22.29x` |
| Gqlgen         | `75,084.98`  | `1.33`       | `17.10x` |
| Netflix DGS    | `57,460.51`  | `0.00`       | `13.09x` |
| Apollo GraphQL | `55,250.27`  | `0.00`       | `12.58x` |
| Hasura         | `4,390.62`   | `22.80`      | `1.00x`  |
