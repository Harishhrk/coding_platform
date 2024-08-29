#!/bin/bash
set -e

# Wait for database to be ready
while ! nc -z db 5432; do
  echo "Waiting for database..."
  sleep 1
done

echo "Database is ready!"

# URL decode the password
DB_PASSWORD=$(echo $DATABASE_URL | sed -E 's/.*:(.*)@.*/\1/' | sed 's/%40/@/g')

# Create or migrate database
PGPASSWORD="$DB_PASSWORD" bundle exec rake db:create db:migrate

# Then exec the container's main process (what's set as CMD in the Dockerfile)
exec "$@"