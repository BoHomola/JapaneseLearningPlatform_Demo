#!/bin/bash

echo "--------------------------------------"
echo "DROPPING DATABASE..."
echo "--------------------------------------"
dotnet run drop --project ./src/JPLearningHub_Server/JPLearningHub_Server.csproj

echo "--------------------------------------"
echo "DELETING MIGRATIONS FOLDER"
echo "--------------------------------------"
rm -r ./src/JPLearningHub_Server/Migrations

echo "--------------------------------------"
echo "ADDING MIGRATION"
echo "--------------------------------------"
dotnet ef migrations add ForceReset --project ./src/JPLearningHub_Server/JPLearningHub_Server.csproj

echo "--------------------------------------"
echo "UPDATING DATABASE"
echo "--------------------------------------"
dotnet ef database update --project ./src/JPLearningHub_Server/JPLearningHub_Server.csproj

echo "--------------------------------------"
echo "SEEDING DATABASE"
echo "--------------------------------------"
dotnet run seed --project ./src/JPLearningHub_Server/JPLearningHub_Server.csproj
