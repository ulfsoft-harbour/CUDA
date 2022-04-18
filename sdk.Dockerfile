ARG CUDA_VERSION=11.6.0
ARG OS_VERSION=ubuntu20.04

FROM nvcr.io/nvidia/cuda:${CUDA_VERSION}-devel-${OS_VERSION}

LABEL maintainer="Krzysztof Begiedza <contact@kbegiedza.eu>"

RUN apt-get update \
    && export DEBIAN_FRONTEND=noninteractive \
    ## Install packages
    && apt-get -y install --no-install-recommends \
    git unzip wget curl \
    ca-certificates build-essential libtool libssl-dev autoconf \
    cppcheck valgrind clang lldb llvm gdb \
    ## Install cmake 3.23.1
    && mkdir -p /tmp/cmake \
    && curl https://cmake.org/files/v3.23/cmake-3.23.1.tar.gz -o /tmp/cmake-3.23.1.tar.gz \
    && tar -xzf /tmp/cmake-3.23.1.tar.gz -C /tmp \
    && /bin/bash /tmp/cmake-3.23.1/bootstrap \
    && make -j$(nproc) && make install \
    && rm -r /tmp/cmake-3.23.1.tar.gz /tmp/cmake-3.23.1 \
    ## Post installation clean-up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*