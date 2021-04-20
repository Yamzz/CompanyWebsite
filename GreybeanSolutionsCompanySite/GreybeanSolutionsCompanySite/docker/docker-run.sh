#!/bin/bash
# ----------------------------------------------
# SUMMARY
# ----------------------------------------------
# This script starts the appropriate containers 
# - 'vsdbg:latest'
# - 'www_greybean'
# ----------------------------------------------

# exit when any command fails
set -e

# define constants 
DOCKER_DIRECTORY=$(cd `dirname $0` && pwd)
DEBUG=false
CONTAINER_NAME=www_greybean

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

# set more constant(s)
BUILD_STATUS=0

# build images 
"$DOCKER_DIRECTORY/docker-build.sh"
BUILD_STATUS=$?

if [ "$BUILD_STATUS" != "0" ];
then
  echo "Build failed"
  exit $BUILD_STATUS
fi

NETWORK_NAME=greybean_www

# create network if it doesn't exist
if [ -z $(docker network ls --filter name=^${NETWORK_NAME}$ --format="{{ .Name }}") ]; 
then 
  echo "Network '$NETWORK_NAME' not found. Creating network..."
  docker network create ${NETWORK_NAME}; 
fi

# create or start the container
if [ -z $(docker ps -aq --filter name=$CONTAINER_NAME) ]; 
then
  echo "Starting container '$CONTAINER_NAME'..."
  if [ "$DEBUG" = "true" ];
  then
    docker-compose -f $DOCKER_DIRECTORY/docker-compose.yml -f $DOCKER_DIRECTORY/debug.docker-compose.yml up
  else 
    docker-compose -f $DOCKER_DIRECTORY/docker-compose.yml up
  fi
else
  if [ -n $(docker ps -q --filter name=$CONTAINER_NAME) ];
  then
    echo "Container '$CONTAINER_NAME' exists! Starting..."
    docker start -a $CONTAINER_NAME
  fi
fi
