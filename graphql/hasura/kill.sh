#!/bin/bash

# Stop and remove PostgreSQL container
docker stop postgres
docker rm postgres

# Stop and remove Hasura GraphQL Engine container
docker stop graphql-engine
docker rm graphql-engine

# Stop and remove Nginx container
docker stop nginx
docker rm nginx

# Remove the Docker network
docker network rm hasura-network

echo "All containers stopped and removed, and Docker network deleted."
