FROM ubuntu:20.04 as dev
MAINTAINER Konrad Malik <konrad.malik@gmail.com>

ENV LANG=C.UTF-8 \
    DEBIAN_FRONTEND=noninteractive \
    APT_INSTALL="apt-get update && apt-get install -y --no-install-recommends --fix-missing" \
    PIP_INSTALL="python -m pip --no-cache-dir install --upgrade" \
    GIT_CLONE="git clone --depth 10" \
    GOPATH=/home/dev/go \
    PATH=$PATH:$GOPATH/bin
RUN groupadd -f dev && useradd dev -g dev -ms /bin/bash
WORKDIR /home/dev

COPY devenv_setup.sh devenv_setup.sh

ARG go_version=1.16.2
ARG python_version=3.8
ARG node_version=14
ARG enable_python
ARG enable_go
ARG enable_rust

RUN ./devenv_setup.sh && rm devenv_setup.sh

# place current user and group id here to have no permission errors after editing files
ARG uid
ARG gid
RUN groupmod -g $gid dev && usermod -u $uid dev
USER dev
