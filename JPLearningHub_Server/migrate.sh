#!/bin/bash

# Wait for the database to be ready
set -e

echo "Starting migration script..."

PROJECT_PATH="/app/JPLearningHub_Server.csproj"

if [ ! -f "$PROJECT_PATH" ]; then
  echo "Project file not found: $PROJECT_PATH"
  exit 1
fi

echo "Project file found: $PROJECT_PATH"

until dotnet ef database update --project "$PROJECT_PATH"; do
    >&2 echo "Database is unavailable - sleeping"
    sleep 6
done

echo "Database migration completed. Starting application..."

# Start the application
dotnet JPLearningHub_Server.dll
