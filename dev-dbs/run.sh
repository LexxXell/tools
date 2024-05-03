#!/bin/bash

# Check if argument is passed
if [ -z "$1" ]; then
  echo "Usage: $0 <project_name> [docker-compose options]"
  exit 1
fi

# Path to the directory containing docker-compose files
COMPOSE_DIR="/home/lexx/workspace/tools/dev-dbs/"

# Path to the docker-compose file for the specified project
COMPOSE_FILE="$COMPOSE_DIR/docker-compose.$1.yml"

# Check if the docker-compose file for the specified project exists
if [ ! -f "$COMPOSE_FILE" ]; then
  echo "Error: Docker compose file for project '$1' not found"
  exit 1
fi

# Remove the first argument (project name) from the argument list
shift

# Run the project using docker-compose, passing any remaining parameters
docker-compose -f "$COMPOSE_FILE" "$@"
