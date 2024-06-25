#!/bin/bash

# Database credentials
DB_NAME="db"
DB_USER="user"
DB_PASSWORD="password"
DB_PORT="5432"

# Create a Docker network
docker network create hasura-network

# Start PostgreSQL container
docker run -d --name postgres \
	--network hasura-network \
	-e POSTGRES_USER=$DB_USER \
	-e POSTGRES_PASSWORD=$DB_PASSWORD \
	-e POSTGRES_DB=$DB_NAME \
	-p $DB_PORT:5432 \
	postgres:13

DB_HOST=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' postgres)

# Wait for PostgreSQL to be ready
echo "Waiting for PostgreSQL to be ready..."
until docker exec postgres pg_isready -U $DB_USER -d $DB_NAME -h $DB_HOST; do
	sleep 1
done
echo "PostgreSQL is ready!"

# Start Hasura GraphQL Engine container
docker run -d --name graphql-engine \
	--network hasura-network \
	-e HASURA_GRAPHQL_DATABASE_URL=postgres://$DB_USER:$DB_PASSWORD@$DB_HOST:$DB_PORT/$DB_NAME \
	-e HASURA_GRAPHQL_ENABLE_CONSOLE=false \
	-e HASURA_GRAPHQL_ENABLED_LOG_TYPES=startup,http-log,webhook-log,websocket-log,query-log \
	-p 8080:8080 \
	hasura/graphql-engine:v2.0.10

# Wait for Hasura to be ready
echo "Waiting for Hasura GraphQL Engine to be ready..."
sleep 10

# Create and insert data into PostgreSQL
psql "postgresql://$DB_USER:$DB_PASSWORD@$DB_HOST:$DB_PORT/$DB_NAME" <<EOF
CREATE SCHEMA IF NOT EXISTS public;

DROP TABLE IF EXISTS public.posts;
DROP TABLE IF EXISTS public.users;

CREATE TABLE public.users (
  id SERIAL PRIMARY KEY,
  name TEXT,
  username TEXT,
  email TEXT,
  phone TEXT,
  website TEXT
);

CREATE TABLE public.posts (
  id SERIAL PRIMARY KEY,
  user_id INTEGER,
  title TEXT,
  body TEXT,
  FOREIGN KEY (user_id) REFERENCES public.users(id)
);
EOF

# Fetch data from APIs
USERS_DATA=$(curl -s http://jsonplaceholder.typicode.com/users)
POSTS_DATA=$(curl -s http://jsonplaceholder.typicode.com/posts)

# Save data to temporary files
echo "$USERS_DATA" >users.json
echo "$POSTS_DATA" >posts.json

# Insert users into the database
jq -c '.[]' users.json | while read -r user; do
	id=$(echo "$user" | jq '.id')
	name=$(echo "$user" | jq -r '.name' | sed "s/'/''/g")
	username=$(echo "$user" | jq -r '.username' | sed "s/'/''/g")
	email=$(echo "$user" | jq -r '.email' | sed "s/'/''/g")
	phone=$(echo "$user" | jq -r '.phone' | sed "s/'/''/g")
	website=$(echo "$user" | jq -r '.website' | sed "s/'/''/g")

	psql "postgresql://$DB_USER:$DB_PASSWORD@$DB_HOST:$DB_PORT/$DB_NAME" -c "INSERT INTO public.users (id, name, username, email, phone, website) VALUES ($id, '$name', '$username', '$email', '$phone', '$website') ON CONFLICT (id) DO NOTHING;"
done

# Insert posts into the database
jq -c '.[]' posts.json | while read -r post; do
	id=$(echo "$post" | jq '.id')
	user_id=$(echo "$post" | jq '.userId')
	title=$(echo "$post" | jq -r '.title' | sed "s/'/''/g")
	body=$(echo "$post" | jq -r '.body' | sed "s/'/''/g")

	psql "postgresql://$DB_USER:$DB_PASSWORD@$DB_HOST:$DB_PORT/$DB_NAME" -c "INSERT INTO public.posts (id, user_id, title, body) VALUES ($id, $user_id, '$title', '$body') ON CONFLICT (id) DO NOTHING;"
done

# Clean up temporary files
rm users.json posts.json

# Apply Hasura metadata
cd ./graphql/hasura
npx hasura metadata apply

# Start Nginx container with custom configuration
docker run -d --name nginx \
	--network hasura-network \
	-v "$(pwd)/nginx.conf:/etc/nginx/conf.d/default.conf" \
	-p 8000:80 \
	nginx:latest

sleep 10
cd ../..
echo "Running..."
