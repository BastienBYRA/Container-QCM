#!/bin/bash

# Remove all possible \r from the .env file, so it can work properly
tr -d '\r' < ./FlutterQCM-Backend/.env > ./FlutterQCM-Backend/.env.tmp && mv ./FlutterQCM-Backend/.env.tmp ./FlutterQCM-Backend/.env
# tr -d '\r' < ./Front/.env > ./Front/.env.tmp && mv ./Front/.env.tmp ./Front/.env

# Charger les variables du fichier .env
source ./FlutterQCM-Backend/.env
# source ./Front/.env

# Build de l'image Docker du Frontend
#

# Build de l'image Docker du Backend
docker build -t "$NODE_IMAGE_NAME:$NODE_IMAGE_TAG" ./FlutterQCM-Backend

# Run the docker compose
docker compose --env-file "./FlutterQCM-Backend/.env" up -d --build