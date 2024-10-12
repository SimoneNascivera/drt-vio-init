FROM ubuntu:18.04

WORKDIR /root

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    wget \
    unzip \
    libopencv-dev \
    libboost-all-dev \
    git \
    tmux \
    cmake \
    build-essential \
    sudo \
    && rm -rf /var/lib/apt/lists/*

RUN apt update && DEBIAN_FRONTEND=noninteractive apt install -y \
    cmake \
    libgoogle-glog-dev \
    libgflags-dev \
    libatlas-base-dev \
    libeigen3-dev \
    libsuitesparse-dev && \
    rm -rf /var/lib/apt/lists/*

RUN git clone https://ceres-solver.googlesource.com/ceres-solver && \
    cd ceres-solver && \
    git checkout 1.14.0 && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j$(nproc) && \
    make install && \
    cd ../.. && \
    rm -rf ceres-solver

RUN apt update && git clone https://github.com/stevenlovegrove/Pangolin.git && \
    cd Pangolin && \
    git checkout v0.8 && \
    sed -i 's/PKGS_OPTIONS+=(install --no-install-suggests --no-install-recommends)/PKGS_OPTIONS+=(install -y --no-install-suggests --no-install-recommends)/g' ./scripts/install_prerequisites.sh && \
    ./scripts/install_prerequisites.sh recommended && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j$(nproc) && \
    make install && \
    cd ../.. && \
    rm -rf ceres-solver

RUN git clone https://github.com/SimoneNascivera/drt-vio-init.git && \
    cd ~/drt-vio-init/ && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j4

CMD [ "/bin/bash" ]