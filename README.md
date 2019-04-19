# Deep learning laboratory

Includes:

- GPU support
- Python 3.7
- Jupyter + Tensorboard
- Pytorch + Ignite + TensorboardX
- Tensorflow + Keras
- Jupyter, numpy, scipy, pandas, skimage, matplotlib, tqdm
- Supervisord

## How to use

Clone repository:
```
git clone https://github.com/vslutov/deeplearning.git
```

Run command:

```
usage: deeplearning.sh [-h] [-j JUPYTER_PORT] [-t TENSORBOARD_PORT]
                       [-p PASSWORD]
                       work_folder

Start deep learning laboratory

positional arguments:
  work_folder

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

Tesnorboard is disabled by default, becouse it's too hungry for ram.
You can enable tensorboard by command `supervisorctl start tensorboard`.

### Multiple GPUs

You can use environment `NVIDIA_VISIBLE_DEVICES` to specify visible devices in container.

## Requirements

1. Ubuntu, CentOS or RHEL.
1. Python 2.6+ or 3.2+, bash.
1. [Docker](https://docs.docker.com/install/#supported-platforms)
1. [Nvidia-docker](https://github.com/NVIDIA/nvidia-docker)

## How it works

Script [deeplearning.sh](deeplearning.sh):

If the container have been already started, run the shell in the container and exit.

1. Update the git repository (could be canceled with `Ctrl-D`).
1. Build the docker image. The first run may take a few minutes.
1. Generate unique jupyter password or take your `-p` option.
1. Create `deeplearning_<name>_data` volume. The name calculated from `work_folder` argument.
1. Run the docker container `deeplearning_<name>` from this image in background.
1. In the container `work_folder` mounts as `/home/user/work` and `deeplearning_<name>_data` as `/home/user/data`.
1. In the container starts supervisor, which launch a jupyter notebook and a tensorboard.
1. If you set the jupyter listening port, then the host port forwards to the jupyter notebook, else a random port sets.
1. The tensorboard runs with folder `data_folder/runs` as input. The listening port sets as like as the jupyter listening port.
1. Print out the container id, jupyter and tensorboard host ports and the jupyter password.
1. Run the shell in the container.
