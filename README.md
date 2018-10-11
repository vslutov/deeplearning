# Deep learning laboratory container

[![Docker Automated build](https://img.shields.io/docker/automated/vslutov/deeplearning.svg)](https://hub.docker.com/r/vslutov/deeplearning/)
[![Docker Build Status](https://img.shields.io/docker/build/vslutov/deeplearning.svg)](https://hub.docker.com/r/vslutov/deeplearning/)

Includes:

- GPU support
- Service manager
- Python 3.6
- Tensorflow + tensorboard + Keras
- Pytorch + Ignite
- Jupyter, numpy, scipy, pandas, skimage, matplotlib, tqdm

## How to use

Download file [start.sh](start.sh) and make it executable.

Run command:

```shell
./start.sh data_folder [jupyter_port [tensorboard_port]]
```
, where `data_folder` is folder that should be mounted as data (with code and data).
