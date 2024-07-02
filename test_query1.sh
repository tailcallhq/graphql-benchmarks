graphqlEndpoint="${1:-http://localhost:8000/graphql}"
curl -i -X POST -d '{"query": "{posts{title}}"}' $graphqlEndpoint -H "Content-Type: application/json"
