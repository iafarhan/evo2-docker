FROM nvidia/cuda:12.4.1-cudnn-devel-ubuntu22.04

ARG DEBIAN_FRONTEND=noninteractive
ENV DEBIAN_FRONTEND=${DEBIAN_FRONTEND} \
    TZ=Etc/UTC \
    PIP_NO_CACHE_DIR=1 \
    PYTHONUNBUFFERED=1

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        tzdata \
        ca-certificates \
        git \
        git-lfs \
        curl \
        build-essential \
        ninja-build \
        cmake \
        python3.11 \
        python3.11-dev \
        python3.11-venv \
        pkg-config && \
    ln -sf /usr/bin/python3.11 /usr/bin/python && \
    ln -sf /usr/bin/pip3 /usr/bin/pip || true && \
    git lfs install --system && \
    rm -rf /var/lib/apt/lists/*

RUN curl -sS https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py && \
    python3.11 /tmp/get-pip.py && rm /tmp/get-pip.py

RUN python3.11 -m pip install --upgrade pip setuptools wheel packaging

RUN python3.11 -m pip install --index-url https://download.pytorch.org/whl/cu124 torch==2.5.1 torchvision==0.20.1 torchaudio==2.5.1

RUN python3.11 -m pip install --no-build-isolation transformer_engine[pytorch]==2.4.0

RUN python3.11 -m pip install --no-build-isolation --upgrade flash-attn

WORKDIR /opt

ARG REV=main
RUN git clone --recurse-submodules --depth 1 --branch ${REV} https://github.com/ArcInstitute/evo2.git && \
    cd evo2 && git submodule update --init --recursive

WORKDIR /opt/evo2
ENV VORTEX_SKIP_LOCAL_FLASH_ATTN=1
RUN sed -i '/vortex\/ops\/attn/ s/^/# SKIPPED BY DOCKER BUILD /' vortex/Makefile || true
RUN python3.11 -m pip install -e .

WORKDIR /workspace

VOLUME ["/root/.cache/huggingface", "/data"]

CMD ["/bin/bash"]
