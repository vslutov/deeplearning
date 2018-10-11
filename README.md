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

## Start
```shell
./start.sh data_folder [jupyter_port [tensorboard_port]]
```

Mount `data_folder` and runs jupyter and tensorboard.
