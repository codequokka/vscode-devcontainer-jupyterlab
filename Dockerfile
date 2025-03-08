FROM ghcr.io/astral-sh/uv:0.6.5 AS uv
FROM python:3.13.2-slim-bookworm

ARG USER=vscode
ARG GROUP=${USER}
ARG UID
ARG GID
ARG WORKDIR=/app

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    sudo=1.9.13p3-1+deb12u1 \
    procps=2:4.0.2-3 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
# TODO: Install the latest version of nodejs
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    nodejs=18.19.0+dfsg-6~deb12u2 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
RUN groupadd -g ${GID} ${GROUP} && \
    useradd -u ${UID} -g ${GID} -G sudo -s /bin/bash -m -l ${USER} && \
    echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoer
COPY --from=uv /uv /uvx /bin/

USER ${USER}
WORKDIR ${WORKDIR}
COPY --chown=${USER}:${GROUP} pyproject.toml uv.lock jupyter_lab_config.py ./
RUN uv sync --frozen
