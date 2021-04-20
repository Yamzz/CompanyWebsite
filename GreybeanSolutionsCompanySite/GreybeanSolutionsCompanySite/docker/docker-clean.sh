#!/bin/bash
# -----------------------------------------------------------------
# SUMMARY
# -----------------------------------------------------------------
# This script does the follwing:
# - force removes the container 'www_greybean'
# - removes the image 'www_greybean'
# -----------------------------------------------------------------

set -e

echo "executing 'docker-clean.sh'..."

# CONSTANTS
IMAGE_NAME=greybean/www:www_greybean
CONTAINER_NAME=www_greybean

# Remove container 
if [ -n "$(docker ps -aq --filter name=$CONTAINER_NAME)" ];
then
  echo "Removing container '$CONTAINER_NAME'..."
  docker rm -f $(docker ps -aq --filter name=$CONTAINER_NAME)
fi

# Remove image
if [ -n "$(docker images -q $IMAGE_NAME)" ];
then
  echo "Removing image '$IMAGE_NAME'..."
  docker image rm $(docker images -q $IMAGE_NAME)
fi

# Remove untagged images
docker rmi $(docker images | grep "^<none>" | awk "{print $3}")