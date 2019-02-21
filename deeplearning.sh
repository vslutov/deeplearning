#!/usr/bin/env bash

# deeplearning - Deep learning laboratory
# Copyright (C) 2018 V. Lutov
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

# argparse function distributed with MIT license
# https://github.com/nhoffman/argparse-bash
# MIT License - Copyright (c) 2015 Noah Hoffman

# Update git repository
if [ -z "$DEEPLEARNING_UPDATED" ]; then
    SOURCE=$(readlink -f "${BASH_SOURCE[0]}")
    ( cd -P "$( dirname "$SOURCE" )" && git pull )
    export DEEPLEARNING_UPDATED=yes
    source ${SOURCE}
    exit
fi

argparse(){
    argparser=$(mktemp 2>/dev/null || mktemp -t argparser)
    cat > "$argparser" <<EOF
from __future__ import print_function
import sys
import argparse
import os


class MyArgumentParser(argparse.ArgumentParser):
    def print_help(self, file=None):
        """Print help and exit with error"""
        super(MyArgumentParser, self).print_help(file=file)
        sys.exit(1)

parser = MyArgumentParser(prog=os.path.basename("$0"),
            description="""Start deep learning laboratory""")
EOF

    # stdin to this function should contain the parser definition
    cat >> "$argparser"

    cat >> "$argparser" <<EOF
args = parser.parse_args()
for arg in [a for a in dir(args) if not a.startswith('_')]:
    key = arg.upper()
    value = getattr(args, arg, None)

    if isinstance(value, bool) or value is None:
        print('{0}="{1}";'.format(key, 'yes' if value else ''))
    elif isinstance(value, list):
        print('{0}=({1});'.format(key, ' '.join('"{0}"'.format(s) for s in value)))
    else:
        print('{0}="{1}";'.format(key, value))
EOF

    # Define variables corresponding to the options if the args can be
    # parsed without errors; otherwise, print the text of the error
    # message.
    if python "$argparser" "$@" &> /dev/null; then
        eval $(python "$argparser" "$@")
        retval=0
    else
        python "$argparser" "$@"
        retval=1
    fi

    rm "$argparser"
    return $retval
}

argparse "$@" <<EOF || exit 1
parser.add_argument('work_folder')
parser.add_argument('-j', '--jupyter-port', default=None, type=int,
                    help='The jupyter listen port [default: some free port]')
parser.add_argument('-t', '--tensorboard-port', default=None, type=int,
                    help='The jupyter listen port [default: some free port]')
parser.add_argument('-p', '--password', default=None, type=str,
                    help='The jupyter password [default: random string]')
EOF

WORK_FOLDER=$(readlink -f "$WORK_FOLDER")
mkdir -p "$WORK_FOLDER"

USERNAME=$(id -un)
WORK_BASENAME=$(basename "$WORK_FOLDER")
WORK_HASH=$(echo "$WORK_FOLDER" | md5sum - | head -c 6)
CONTAINER_NAME="${USERNAME}_deeplearning_${WORK_BASENAME}_${WORK_HASH}"
VOLUME_NAME="${CONTAINER_NAME}_data"

start_shell () {
  echo "Now it starts a shell into the container"
  docker exec -it $CONTAINER_NAME /usr/bin/zsh
}

if docker inspect "$CONTAINER_NAME" >/dev/null 2>&1 ; then
  start_shell
  exit
fi

# If ports set, we shoult send it to docker
if [ -n "${JUPYTER_PORT}" ] ; then
  JUPYTER_PORT="-p $JUPYTER_PORT:8888"
fi

if [ -n "${TENSORBOARD_PORT}" ] ; then
  TENSORBOARD_PORT="-p $TENSORBOARD_PORT:6006"
fi

if [ -z "${PASSWORD}" ] ; then
  # Generate password for jupyter
  PASSWORD=$(date +%s | sha256sum | base64 | head -c 32)
fi

if [ -z "${NB_USER}" ] ; then
  # Generate password for jupyter
  NB_USER=user
fi

# Update image
get_script_dir () {
    SOURCE=$(readlink -f "${BASH_SOURCE[0]}")
    echo $( cd -P "$( dirname "$SOURCE" )" && pwd )
}
IMAGE="${USERNAME}/deeplearning:local"

echo -n "Build docker image..."
docker build -t "$IMAGE" --build-arg "NB_UID=$(id -u)" --build-arg "NB_GID=$(id -g)" --build-arg "NB_USER=${NB_USER}" "$(get_script_dir)" >/dev/null
echo "Done"

# Create volume
docker volume create "${VOLUME_NAME}" >/dev/null

# Run docker
CONTAINER_ID=$(docker run --runtime=nvidia --shm-size 8G -e "NVIDIA_VISIBLE_DEVICES=$NVIDIA_VISIBLE_DEVICES" -d --rm -e "PASSWORD=$PASSWORD" \
               -P $JUPYTER_PORT $TENSORBOARD_PORT \
               "--name=$CONTAINER_NAME" \
               "--hostname=$WORK_BASENAME" \
               "--volume=$WORK_FOLDER:/home/${NB_USER}/work" \
               "--volume=$VOLUME_NAME:/home/${NB_USER}/data" \
               "$IMAGE")
DOCKER_CODE="$?"

if [ "$DOCKER_CODE" -ne "0" ]; then
  # Something goes wrong
  exit "$DOCKER_CODE"
fi

# Get service ports
JUPYTER_URL=$(docker port "$CONTAINER_ID" | grep -e "^8888" | grep -o -e "\\S\\+$")
TENSORBOARD_URL=$(docker port "$CONTAINER_ID" | grep -e "^6006" | grep -o -e "\\S\\+$")

# Show log
echo "Jupyter: http://$JUPYTER_URL"
echo "Tensorboard: http://$TENSORBOARD_URL"
echo "Password: $PASSWORD"
echo
echo "Stop the container: 'docker kill $CONTAINER_NAME'"
echo

start_shell
