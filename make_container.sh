#!/bin/bash
BASE_IMAGE_NAME="cubrid-wsl2"
IP_D_CLASS=80

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
    COUNT=$((COUNT+1))
    IP_LAST_ADDRESS=$((${IP_D_CLASS}+${COUNT}))
    IP_ADDRESS="192.168.50.${IP_LAST_ADDRESS}"

    echo "Creating image for ${TAG_NAME}"
    echo "IP_LAST_ADDRESS: ${IP_LAST_ADDRESS}"
    echo "IP_ADDRESS: ${IP_ADDRESS}"

    IMAGE_NAME="${BASE_IMAGE_NAME}:${TAG_NAME}"
    CONTAINER_NAME="cubrid-${TAG_NAME}-${IP_LAST_ADDRESS}"

    docker run --detach \
        --name ${CONTAINER_NAME} \
        --hostname ${CONTAINER_NAME} \
        --network dev-net \
        --ip=${IP_ADDRESS} \
        --volume /sys/fs/cgroup:/sys/fs/cgroup:ro \
        --cap-add=ALL \
        --privileged \
        --restart always \
        ${IMAGE_NAME}
done
