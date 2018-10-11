FROM nvidia/cuda:9.0-cudnn7-devel
ENV PROJECT_ROOT=/lab

SHELL ["/bin/bash", "-c"]
RUN apt-get update && apt-get -y upgrade && \
    apt-get install -y curl git python3-dev python3-pip build-essential libz-dev libsqlite3-dev \
                       libbz2-dev vim libncurses-dev libssl-dev openssl libffi-dev skalibs-dev \
                       libreadline6-dev supervisor && \
    apt-get clean && \
\
    curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash && \
    echo 'export PATH="/root/.pyenv/bin:$PATH"' >~/.bashrc && \
    echo 'eval "$(pyenv init -)"' >>~/.bashrc && \
    echo 'eval "$(pyenv virtualenv-init -)"' >>~/.bashrc && \
    source ~/.bashrc && \
    pyenv install 3.6.6 && pyenv virtualenv 3.6.6 deep && pyenv global deep && \
\
    pip install --upgrade pip && \
    pip install torch torchvision pytorch-ignite jupyter scikit-image scikit-learn matplotlib \
                numpy scipy pandas Pillow tqdm Keras tensorflow-gpu tensorboard tensorboardX && \
\
    mkdir -p $PROJECT_ROOT ~/.jupyter && \
    ln -s /usr/local/cuda-9.0/targets/x86_64-linux/lib/stubs/libcuda.so /usr/lib/libcuda.so.1

WORKDIR $PROJECT_ROOT
COPY supervisord.conf /etc/supervisord.conf
EXPOSE 8888/tcp 6006/tcp

CMD supervisord -c /etc/supervisord.conf
