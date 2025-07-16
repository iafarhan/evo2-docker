FROM nvidia/cuda:12.4.1-cudnn-devel-ubuntu22.04

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

# (base) ubuntu@se-h2-28-gpu:~/evo2-docker$ docker compose up --build
# WARN[0000] /home/ubuntu/evo2-docker/compose.yaml: the attribute `version` is obsolete, it will be ignored, please remove it to avoid potential confusion
# Compose can now delegate builds to bake for better performance.
#  To do so, set COMPOSE_BAKE=true.
# [+] Building 979.5s (2/2) FINISHED                                              docker-container:nesa-builder
#  => [evo2 internal] load build definition from Dockerfile                                                0.0s
#  => => transferring dockerfile: 805B                                                                     0.0s
#  => ERROR [evo2 internal] load metadata for nvcr.io/nvidia/cuda:12.4.1-cudnn-devel-ubuntu22.04         979.5s
# ------
#  > [evo2 internal] load metadata for nvcr.io/nvidia/cuda:12.4.1-cudnn-devel-ubuntu22.04:
# ------
# failed to solve: failed to fetch anonymous token: unexpected status from GET request to https://authn.nvidia.com/token?scope=repository%3Anvidia%2Fcuda%3Apull&service=registry: 401 Unauthorized