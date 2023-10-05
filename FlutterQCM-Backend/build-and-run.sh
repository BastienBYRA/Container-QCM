#!/bin/bash

# Remove all possible \r from the .env file, so it can work properly
tr -d '\r' < .env > .env.tmp && mv .env.tmp .env

# Charger les variables du fichier .env
source .env

# Utiliser les variables dans votre script
echo "Image name: $NODE_IMAGE_NAME"
echo "Image tag: $NODE_IMAGE_TAG"

# Build de l'image Docker
docker build -t "$NODE_IMAGE_NAME:$NODE_IMAGE_TAG" .

# Run the docker compose
docker compose up