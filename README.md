# Deep learning laboratory container

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

```shell
./deeplearning.sh data_folder [jupyter_port [tensorboard_port]]
```
, where `data_folder` is folder that should be mounted as data (with code and data).
