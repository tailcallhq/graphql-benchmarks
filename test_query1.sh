graphqlEndpoint="${1:-http://localhost:8000/graphql}"
curl -i -X POST -d '{"query": "{posts{id,userId, title, user{id, name, email}}}"}' $graphqlEndpoint -H "Content-Type: application/json"
