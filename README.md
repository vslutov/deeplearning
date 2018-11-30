# Deep learning laboratory

[![Docker Automated build](https://img.shields.io/docker/automated/vslutov/deeplearning.svg)](https://hub.docker.com/r/vslutov/deeplearning/)
[![Docker Build Status](https://img.shields.io/docker/build/vslutov/deeplearning.svg)](https://hub.docker.com/r/vslutov/deeplearning/)

Includes:

- GPU support
- Python 3.6
- Jupyter + Tensorboard
- Pytorch + Ignite + TensorboardX
- Tensorflow + Keras
- Jupyter, numpy, scipy, pandas, skimage, matplotlib, tqdm
- Supervisord

## How to use

Download file [deeplearning.sh](deeplearning.sh) and make it executable.

Run command:

```
usage: deeplearning.sh [-h] [-j JUPYTER_PORT] [-t TENSORBOARD_PORT]
                       [-p PASSWORD]
                       data_folder

Start deep learning laboratory

positional arguments:
  data_folder

optional arguments:
  -h, --help            show this help message and exit
  -j JUPYTER_PORT, --jupyter-port JUPYTER_PORT
                        The jupyter listen port [default: some free port]
  -t TENSORBOARD_PORT, --tensorboard-port TENSORBOARD_PORT
                        The jupyter listen port [default: some free port]
  -p PASSWORD, --password PASSWORD
                        The jupyter password [default: random string]
```

If you shut down jupyter server, container will shut down.

## Requirements

1. Ubuntu, CentOS or RHEL.
1. Python 2.6+ or 3.2+, bash.
1. [Docker](https://docs.docker.com/install/#supported-platforms)
1. [Nvidia-docker](https://github.com/NVIDIA/nvidia-docker)

## How it works

Script [deeplearning.sh](deeplearning.sh):

1. Pull latest image from docker hub.
1. Generate unique jupyter password.
1. Run the docker container from this image in background.
1. In the container `data_folder` mounts as `/lab`.
1. In the container starts supervisor, which launch a jupyter notebook and a tensorboard.
1. If you set the jupyter listening port, then the host port forwards to the jupyter notebook, else a random port sets.
1. The tensorboard runs with folder `data_folder/runs` as input. The listening port sets as like as the jupyter listening port.
1. Print out the container id, jupyter and tensorboard host ports and the jupyter password.
1. If you prefer run vim in container, run `:PluginInstall` command to install usefull plugins.
