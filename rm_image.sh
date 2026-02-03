#!/bin/bash

BASE_IMAGE_NAME="cubrid-wsl2"
TAGLIST=(
    "latest"
    "11.4"
    "11.3"
    "11.2"
    "11.0"
    "10.2"
    "10.1"
    "10.0"
)

for TAG_NAME in ${TAGLIST[@]}; do
    echo "Removing image for ${TAG_NAME}"
    IMAGE_NAME="${BASE_IMAGE_NAME}:${TAG_NAME}"

    docker rmi ${IMAGE_NAME}
done
