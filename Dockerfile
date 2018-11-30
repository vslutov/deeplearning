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

FROM nvidia/cuda:9.0-cudnn7-devel

LABEL maintainer="Vladimir Lutov <vs@lutov.net>"

ARG NB_USER="user"
ARG NB_UID="1000"
ARG NB_GID="100"

ENV NB_USER=$NB_USER \
    NB_UID=$NB_UID \
    NB_GID=$NB_GID \
    DEBIAN_FRONTEND=noninteractive

ADD fix-permissions /usr/local/bin/fix-permissions
ADD home /home/$NB_USER

SHELL ["/bin/bash", "-c"]
RUN apt-get update && apt-get -yq dist-upgrade && \
    apt-get install -yq curl git python3-dev python3-pip \
                        build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev \
                        libsqlite3-dev wget curl llvm libncurses5-dev xz-utils tk-dev libxml2-dev \
                        libxmlsec1-dev libffi-dev \
                        supervisor htop vim tmux zsh mc trash-cli \
                        locales sudo wget bzip2 ca-certificates fonts-liberation && \
    apt-get clean && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen && \
    ln -s /usr/local/cuda-9.0/targets/x86_64-linux/lib/stubs/libcuda.so /usr/lib/libcuda.so.1  && \
    useradd -s /usr/bin/zsh -N -u $NB_UID $NB_USER && \
    mkdir -p /home/$NB_USER/work && \
    fix-permissions /home/$NB_USER

USER $NB_UID
ENV USER=$NB_USER \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    SHELL=/usr/bin/zsh
SHELL ["/usr/bin/zsh", "-c"]

RUN git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh && \
    git clone git://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting && \
    git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim && \
    curl -sL https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | zsh && \
    source /home/$NB_USER/.zshrc && \
    pyenv install 3.6.6 && pyenv virtualenv 3.6.6 deep && pyenv global deep && \
\
    pip install --upgrade pip && \
    pip install torch torchvision pytorch-ignite jupyter matplotlib numpy scipy pandas \
                Pillow tqdm Keras tensorflow-gpu tensorboard tensorboardX \
                requests scikit-image scikit-learn scikit-video

COPY supervisord.conf /etc/supervisord.conf
EXPOSE 8888/tcp 6006/tcp
WORKDIR /home/$USER/work

CMD supervisord -c /etc/supervisord.conf
