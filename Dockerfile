FROM nvcr.io/nvidia/cuda:12.4.1-cudnn-devel-ubuntu22.04

RUN apt-get update && apt-get install -y software-properties-common git curl && \
    add-apt-repository ppa:deadsnakes/ppa -y && \
    apt-get update && \
    apt-get install -y python3.11 python3.11-dev && \
    rm -rf /var/lib/apt/lists/*

RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python3.11 get-pip.py && \
    rm get-pip.py

RUN python3.11 -m pip install --upgrade pip setuptools wheel

RUN python3.11 -m pip install torch --index-url https://download.pytorch.org/whl/cu124

RUN python3.11 -m pip install transformer-engine

WORKDIR /app

RUN git clone --recurse-submodules https://github.com/iafarhan/evo2-docker.git .

RUN python3.11 -m pip install .

ENV PYTHONUNBUFFERED=1