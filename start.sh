#!/usr/bin/env bash

if [ $# -lt 1 ]; then
    echo "usage: $0 data_folder [jupyter_port [tensorboard_port]]"
    exit 1
fi

DATA_FOLDER=$1

# If ports set, we shoult send it to docker
JUPYTER_PORT="${2:+-p $2:8888}"
TENSORBOARD_PORT="${3:+-p $3:6006}"

# Generate password for jupyter
PASSWORD=$(date +%s | sha256sum | base64 | head -c 32)

# Update image
IMAGE=deeplearning:dev
# TODO: docker pull "$IMAGE"

# Run docker
CONTAINER_ID=$(docker run --runtime=nvidia -d --rm -e "PASSWORD=$PASSWORD" \
               -P $JUPYTER_PORT $TENSORBOARD_PORT \
               "--volume=$DATA_FOLDER:/lab" "$IMAGE")
DOCKER_CODE="$?"

if [ "$DOCKER_CODE" -ne "0" ]; then
  # Something goes wrong
  exit "$DOCKER_CODE"
fi

# Get service ports
JUPYTER_URL=$(docker port "$CONTAINER_ID" | grep -e "^6006" | grep -o -e "\\S\\+$")
TENSORBOARD_URL=$(docker port "$CONTAINER_ID" | grep -e "^8888" | grep -o -e "\\S\\+$")

# Show log
echo "Container ID: $CONTAINER_ID"
echo "Jupyter: http://$JUPYTER_URL"
echo "Tensorboard port: http://$TENSORBOARD_URL"
echo "Password: $PASSWORD"
