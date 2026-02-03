#!/bin/bash
BASE_IMAGE_NAME="cubrid-wsl2"
IP_D_CLASS=80

TAGLIST=(
    "11.4"
    "11.3"
    "11.2"
    "11.0"
    "10.2"
    "10.1"
    "10.0"
)


for TAG_NAME in ${TAGLIST[@]}; do
    COUNT=$((COUNT+1))
    IP_LAST_ADDRESS=$((${IP_D_CLASS}+${COUNT}))
    IP_ADDRESS="192.168.50.${IP_LAST_ADDRESS}"

    echo "Stopping and removing container for ${TAG_NAME}"
    echo "IP_LAST_ADDRESS: ${IP_LAST_ADDRESS}"
    echo "IP_ADDRESS: ${IP_ADDRESS}"

    CONTAINER_NAME="cubrid-${TAG_NAME}-${IP_LAST_ADDRESS}"
    docker stop ${CONTAINER_NAME}
    docker rm ${CONTAINER_NAME}
done
