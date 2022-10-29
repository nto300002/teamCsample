#!/bin/bash

docker-compose exec django ./manage.py makemigrations
docker-compose exec django ./manage.py migrate
