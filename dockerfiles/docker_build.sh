#!/bin/bash

FLINK_VERSION=1.17
ENV_FILE=build_env_${FLINK_VERSION}.env

FLINK_BASE_DOCKERFILE=Dockerfile.flink-base
FLINK_BASE_DOCKER_TAG="flink-base:v1"

source ${ENV_FILE}

set -x
./download_dependencies.sh $DEPENDENCY_DIR


docker build --no-cache --build-arg "DEPENDENCY_DIR=$DEPENDENCY_DIR" -f $FLINK_BASE_DOCKERFILE -t $FLINK_BASE_DOCKER_TAG .

# docker build --no-cache --build-arg "DEPENDENCY_DIR=$DEPENDENCY_DIR" -f $FLINK_CDC_DOCKERFILE -t $FLINK_CDC_DOCKER_TAG .

# # https://stackoverflow.com/a/74023547 to use local image
# DOCKER_BUILDKIT=0 docker build --no-cache --pull=false -f $FLINK_PAIMON_DOCKERFILE -t $FLINK_PAIMON_DOCKER_TAG .

