#!/bin/bash

SHELL_PATH=$(dirname $(readlink -f $0))

BASE_IMAGE_NAME="cubrid-wsl2"
TAGLIST=(
    "latest"
    "11.4"
)
# TAGLIST=(
#     "latest"
#     "11.4"
#     "11.3"
#     "11.2"
#     "11.0"
#     "10.2"
#     "10.1"
#     "10.0"
# )

if [ -d ${SHELL_PATH}/tar_images ]; then
    rm -rf ${SHELL_PATH}/tar_images
fi

if [ -d ${SHELL_PATH}/targz_images ]; then
    rm -rf ${SHELL_PATH}/targz_images
fi

mkdir -p ${SHELL_PATH}/tar_images
mkdir -p ${SHELL_PATH}/targz_images

for TAG_NAME in ${TAGLIST[@]}; do
    echo "Creating image for ${TAG_NAME}"
    IMAGE_NAME="${BASE_IMAGE_NAME}:${TAG_NAME}"
    CONTAINER_NAME="cubrid-${TAG_NAME}"
    WSL2_IMAGE_NAME="cubrid-wsl2.tar"
    COPY_IMAGE_NAME="cubrid-wsl2-${TAG_NAME}.tar"
    WSL2_IMAGE_NAME_GZ="cubrid-wsl2-${TAG_NAME}.tar.gz"

    # echo "Pulling image ${IMAGE_NAME}"
    # docker pull ${IMAGE_NAME}
    echo "Creating container ${CONTAINER_NAME}"
    docker create -i --name ${CONTAINER_NAME} ${IMAGE_NAME}
    echo "Exporting container ${CONTAINER_NAME} to ${WSL2_IMAGE_NAME}"
    docker export --output ${WSL2_IMAGE_NAME} ${CONTAINER_NAME}
    tar -czf ${WSL2_IMAGE_NAME_GZ} ${WSL2_IMAGE_NAME}
    mv ${WSL2_IMAGE_NAME_GZ} ${SHELL_PATH}/targz_images/
    mv ${WSL2_IMAGE_NAME} ${SHELL_PATH}/tar_images/${COPY_IMAGE_NAME}
    echo "Removing container ${CONTAINER_NAME}"
    docker rm ${CONTAINER_NAME}
done
