#!/bin/bash

# Stop and remove PostgreSQL container
docker stop postgres
docker rm postgres

# Stop and remove Hasura GraphQL Engine container
docker stop graphql-engine
docker rm graphql-engine

# Stop and remove handler container
docker stop handler
docker rm handler
