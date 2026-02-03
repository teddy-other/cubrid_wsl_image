#!/bin/bash

SHELL_PATH=$(dirname $(readlink -f $0))

LATEST_TAG_NAME="11.4"
TAGLIST=(
    "11.4"
)
# TAGLIST=(
#     "11.4"
#     "11.3"
#     "11.2"
#     "11.0"
#     "10.2"
#     "10.1"
#     "10.0"
# )

for TAG_NAME in ${TAGLIST[@]}; do
    echo "Building image for ${TAG_NAME}"
    BUILD_DIR_PATH=${SHELL_PATH}/../cubrid-docker/${TAG_NAME}
    cp -f ${SHELL_PATH}/cubrid.sh ${BUILD_DIR_PATH}/cubrid.sh
    cp -f ${SHELL_PATH}/docker-entrypoint.sh ${BUILD_DIR_PATH}/docker-entrypoint.sh

    cd ${BUILD_DIR_PATH}
    if [ $TAG_NAME == ${LATEST_TAG_NAME} ]; then
        docker build -t cubrid-wsl2:latest ${BUILD_DIR_PATH}
        docker build -t cubrid-wsl2:${TAG_NAME} ${BUILD_DIR_PATH}
    fi
done