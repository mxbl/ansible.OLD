#!/bin/bash
# Build basic docker image from ./Dockerfile
# to run it:
#  $ docker run --rm -it base

# Enable docker buildkit for this run
# Or make it permanent with
#  $ echo "{ \"features\": { \"buildkit\": true } }" >> /etc/docker/daemon.json
export DOCKER_BUILDKIT=1

docker build --ssh default --rm -t base .

# Delete all unused images/containers
docker container prune -f
docker image prune -f
