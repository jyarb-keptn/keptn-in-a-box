#!/bin/bash

# Pull docker image
docker pull jenkins/jenkins:2.288

# we build the image and tag it
docker build -t pcjeffmac/jenkins:2.288 .

# Pushit to dockerhub
docker push pcjeffmac/jenkins:2.288