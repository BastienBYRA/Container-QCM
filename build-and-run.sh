#!/bin/bash

# Remove all possible \r from the .env file, so it can work properly
tr -d '\r' < ./FlutterQCM-Backend/.env > ./FlutterQCM-Backend/.env.tmp && mv ./FlutterQCM-Backend/.env.tmp ./FlutterQCM-Backend/.env
tr -d '\r' < ./appqcm/.env > ./appqcm/.env.tmp && mv ./appqcm/.env.tmp ./appqcm/.env

# Charger les variables du fichier .env
source ./FlutterQCM-Backend/.env
source ./appqcm/.env

# Build de l'image Docker du Frontend
docker build -t "$NODE_IMAGE_NAME:$NODE_IMAGE_TAG" ./FlutterQCM-Backend

# Build de l'image Docker du Backend
docker build -t "$FLUTTER_IMAGE_NAME:$FLUTTER_IMAGE_TAG" ./appqcm

# Run the docker compose
docker compose --env-file "./appqcm/.env" --env-file "./FlutterQCM-Backend/.env" up -d --build