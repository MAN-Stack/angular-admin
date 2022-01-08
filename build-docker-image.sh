#!/usr/bin/env bash
set -e

DOCKER_REGISTRY=ydc-docker-registry.yse.fra.hybris.com:8123
TAG=${2:-dev}
IMAGE_NAME=ui-service

echo "Building app using configuration"

#ng build --output-path=dist
ng build --prod --aot  --output-path=dist

echo "Creating docker image ${IMAGE_NAME}:${TAG}"
docker build -t ${IMAGE_NAME}:${TAG} .
IMAGE_ID=`docker images -q ${IMAGE_NAME}:${TAG}`
echo $IMAGE_ID
docker tag $IMAGE_ID ${DOCKER_REGISTRY}/${IMAGE_NAME}:${TAG}
docker push ${DOCKER_REGISTRY}/${IMAGE_NAME}:${TAG}
