#!/bin/bash
# Build basic docker image from ./Dockerfile
# to run it:
#  $ docker run --rm -it basic

docker build --rm -t basic .

# Delete all unused images/containers
docker container prune -f
docker image prune -f
