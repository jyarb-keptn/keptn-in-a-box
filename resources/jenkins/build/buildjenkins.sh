#!/bin/bash

# Pull docker image
docker pull jenkins/jenkins:2.288

docker images

# create personal docker image
docker tag jenkins/jenkins:2.288 pcjeffmac/jenkins:2.288

docker images

# Pushit to dockerhub
docker push pcjeffmac/jenkins:2.288