#!/bin/bash

# Stop and remove PostgreSQL container
docker stop postgres
docker rm postgres

# Stop and remove Hasura GraphQL Engine container
docker stop graphql-engine
docker rm graphql-engine
