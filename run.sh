#!/bin/bash

docker compose --env-file "./appqcm/.env" --env-file "./FlutterQCM-Backend/.env" up -d --build