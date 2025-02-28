FROM python:3.13-slim-bookworm

ARG USER=vscode
ARG GROUP=vscode
ARG UID=${UID}
ARG GID=${GID}
ARG WORKDIR=/app

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    sudo=1.9.13p3-1+deb12u1 \
    procps && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    nodejs=18.19.0+dfsg-6~deb12u2 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN groupadd -g ${GID} ${GROUP} && \
    useradd -u ${UID} -g ${GID} -G sudo -s /bin/bash -m -l ${USER} && \
    echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoer

USER ${USER}
WORKDIR ${WORKDIR}
# TODO: Investigate why the owner of the copied file is not USER
COPY requirements.txt requirements-dev.txt ./
COPY jupyter_lab_config.py ./
# hadolint ignore=SC1091
RUN python3 -m venv .venv && \
    . .venv/bin/activate && \
    pip install --no-cache-dir --upgrade pip==25.0.1 && \
    pip install --no-cache-dir -r requirements-dev.txt
