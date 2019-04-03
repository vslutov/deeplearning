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

ENV DEBIAN_FRONTEND=noninteractive \
    NB_USER="user" \
    PRE_UID="1000" \
    PRE_GID="1000"

ADD home /home/$NB_USER
ADD requirements.txt /home/$NB_USER/

SHELL ["/bin/bash", "-c"]
RUN apt-get update && apt-get -yq dist-upgrade && \
    apt-get install -yq git python3-dev python3-pip \
                        build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev \
                        libsqlite3-dev wget curl llvm libncurses5-dev xz-utils tk-dev libxml2-dev \
                        libxmlsec1-dev libffi-dev \
                        supervisor htop vim tmux zsh mc trash-cli \
                        locales sudo wget bzip2 ca-certificates fonts-liberation \
                        mercurial && \
    curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash && \
    apt-get install -yq git-lfs && \
    apt-get clean && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen && \
    ln -s /usr/local/cuda-9.0/targets/x86_64-linux/lib/stubs/libcuda.so /usr/lib/libcuda.so.1  && \
    groupadd -g $PRE_GID $NB_USER && \
    useradd -s /usr/bin/zsh -N -u $PRE_UID -g $PRE_GID $NB_USER && \
    mkdir -p /home/$NB_USER/work /home/$NB_USER/data && \
    chown -R $PRE_UID:$PRE_GID /home/$NB_USER

USER $PRE_UID
ENV USER=$NB_USER \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    SHELL=/usr/bin/zsh
SHELL ["/usr/bin/zsh", "-c"]

RUN git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh && \
    git clone git://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting && \
    git clone --recursive git://github.com/joel-porquet/zsh-dircolors-solarized ~/.oh-my-zsh/custom/plugins/zsh-dircolors-solarized && \
    git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim && \
    git clone git://github.com/altercation/vim-colors-solarized.git ~/.vim/bundle/vim-colors-solarized && \
    vim -c 'PluginInstall' -c 'qa!' && \
    curl -sL https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | zsh && \
    source /home/$NB_USER/.zshrc && \
    pyenv install 3.6.8 && pyenv virtualenv 3.6.8 deep && pyenv global deep && \
\
    pip install --upgrade pip && \
    pip install -r /home/$NB_USER/requirements.txt && \
    git clone https://github.com/NVIDIA/apex.git /home/$NB_USER/apex && \
    cd /home/$NB_USER/apex && python setup.py install --cuda_ext --cpp_ext && cd /home/$NB_USER/ && \
    /bin/rm -rf /home/$NB_USER/requirements.txt /home/$NB_USER/apex

COPY supervisord.conf /etc/supervisord.conf
EXPOSE 8888/tcp 6006/tcp
WORKDIR /home/$NB_USER/work

CMD supervisord -c /etc/supervisord.conf
