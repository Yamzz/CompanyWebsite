#!/bin/bash
# --------------------------------------
# SUMMARY
# --------------------------------------
# This script builds the follwing images 
# - 'vsdbg:latest'
# - 'www_greybean'
# --------------------------------------

set -e

DOCKER_DIRECTORY=$(cd `dirname $0` && pwd)
DEBUG=false
IMAGE_NAME=greybean/www:www_greybean

while getopts d-: SWITCH; do
	case $SWITCH in
		f)	DEBUG=true ;;
		-)	VAL="${OPTARG#*=}"
			case $OPTARG in
				DEBUG)		DEBUG=true ;;
				DEBUG*)		DEBUG=${VAL:-true} ;;
				'' )		break ;;
				* )			echo "illegal option --$OPTARG" >&2; exit 1 ;;
			esac ;;
	esac
done
shift $((OPTIND-1))

echo "Running 'docker-build.sh'..."

# check for 'image => vsdbg:latest'
if [ -z $(docker images -q vsdbg:latest) ];
then
  if [ "$DEBUG" = "true" ];
  then
    echo "Building image 'vsdbg:latest'..."
    docker build -f $DOCKER_DIRECTORY/debug-image.dockerfile -t vsdbg ./
  fi
else
  echo "The image 'vsdbg:latest' exists!"
fi

# check for 'image => $IMAGE_NAME'
if [ -z $(docker images -q $IMAGE_NAME) ];
then
  echo "Building image '$IMAGE_NAME'..."
  if [ "$DEBUG" = "true" ];
  then
    docker-compose -f $DOCKER_DIRECTORY/docker-compose.yml -f $DOCKER_DIRECTORY/debug.docker-compose.yml build
  else
    docker-compose -f $DOCKER_DIRECTORY/docker-compose.yml build
  fi
  
else 
  echo "The image '$IMAGE_NAME' exists!"
fi