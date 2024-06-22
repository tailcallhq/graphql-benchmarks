curl -i -X POST -d '{"query": "{posts{id, userId, title, user{id, name, email}}}"}' http://localhost:8000/graphql -H "Content-Type: application/json"
