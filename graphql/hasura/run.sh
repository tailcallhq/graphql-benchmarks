#!/bin/bash

# Database credentials
DB_NAME="db"
DB_USER="user"
DB_PASSWORD="password"
DB_PORT="5432"

# Start PostgreSQL container
docker run -d --name postgres \
  -e POSTGRES_USER=$DB_USER \
  -e POSTGRES_PASSWORD=$DB_PASSWORD \
  -e POSTGRES_DB=$DB_NAME \
  -p $DB_PORT:5432 \
  postgres:13

DB_HOST=127.0.0.1

# Wait for PostgreSQL to be ready
echo "Waiting for PostgreSQL to be ready..."
until docker exec postgres pg_isready -U $DB_USER -d $DB_NAME -h $DB_HOST; do
  sleep 1
done
echo "PostgreSQL is ready!"

docker run -d --name handler \
  --network host \
  --mount type=bind,source="/home/runner/work/graphql-benchmarks/graphql-benchmarks/graphql/hasura",target=/app \
  node:14 bash -c "cd /app && npm install && node handler.js"

HANDLER_URL=127.0.0.1
HANDLER_URL="http://$HANDLER_URL:4000"

# Start Hasura GraphQL Engine container
docker run -d --name graphql-engine \
  -e HASURA_GRAPHQL_ACTION_HANDLER_URL=$HANDLER_URL \
  -e HASURA_GRAPHQL_DATABASE_URL=postgres://$DB_USER:$DB_PASSWORD@$DB_HOST:$DB_PORT/$DB_NAME \
  -e HASURA_GRAPHQL_ENABLE_CONSOLE=false \
  -e HASURA_GRAPHQL_ENABLED_LOG_TYPES=startup,http-log,webhook-log,websocket-log,query-log \
  -e HASURA_GRAPHQL_EXPERIMENTAL_FEATURES=naming_convention \
  -e HASURA_GRAPHQL_DEFAULT_NAMING_CONVENTION=graphql-default \
  --network host \
  hasura/graphql-engine:v2.40.0

# Apply Hasura metadata
cd ./graphql/hasura
npx hasura metadata apply
cd ../..
