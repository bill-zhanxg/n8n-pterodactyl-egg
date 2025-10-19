FROM --platform=$TARGETOS/$TARGETARCH node:slim
LABEL author="Bill Zhang" maintainer="contact@mail.bill-zhanxg.com"
LABEL org.opencontainers.image.title="n8n"
LABEL org.opencontainers.image.description="Workflow Automation Tool"
LABEL org.opencontainers.image.source="https://github.com/n8n-io/n8n"
LABEL org.opencontainers.image.url="https://n8n.io"

# Variables
ARG N8N_VERSION=latest
ENV N8N_VERSION=${N8N_VERSION}
ENV NODE_ENV=production
ENV N8N_RELEASE_TYPE=stable
ENV USER=container HOME=/home/container

# Install dependencies
RUN apt update && apt -y install \
    git gcc g++ ca-certificates dnsutils curl iproute2 ffmpeg procps tini wget tar sqlite3 \
    && useradd -m -d /home/container container

# Install n8n
RUN npm install -g --omit=dev n8n@${N8N_VERSION} --ignore-scripts \
    && npm rebuild --prefix=/usr/local/lib/node_modules/n8n sqlite3 \
    && rm -rf /usr/local/lib/node_modules/n8n/node_modules/@n8n/chat \
    /usr/local/lib/node_modules/n8n/node_modules/@n8n/design-system \
    /usr/local/lib/node_modules/n8n/node_modules/n8n-editor-ui/node_modules \
    /root/.npm \
    && find /usr/local/lib/node_modules/n8n -type f \( -name "*.ts" -o -name "*.js.map" -o -name "*.vue" \) -delete

# Download the task-runner-launcher
ARG TARGETPLATFORM
ARG LAUNCHER_VERSION=1.4.0
COPY n8n-task-runners.json /etc/n8n-task-runners.json
RUN \
    if [ "$TARGETPLATFORM" = "linux/amd64" ]; then export ARCH_NAME="amd64"; \
    elif [ "$TARGETPLATFORM" = "linux/arm64" ]; then export ARCH_NAME="arm64"; fi; \
    mkdir /launcher-temp && cd /launcher-temp && \
    wget https://github.com/n8n-io/task-runner-launcher/releases/download/${LAUNCHER_VERSION}/task-runner-launcher-${LAUNCHER_VERSION}-linux-${ARCH_NAME}.tar.gz && \
    wget https://github.com/n8n-io/task-runner-launcher/releases/download/${LAUNCHER_VERSION}/task-runner-launcher-${LAUNCHER_VERSION}-linux-${ARCH_NAME}.tar.gz.sha256 && \
    echo "$(cat *.sha256) task-runner-launcher-${LAUNCHER_VERSION}-linux-${ARCH_NAME}.tar.gz" > checksum.sha256 && \
    sha256sum -c checksum.sha256 && \
    tar xvf task-runner-launcher-${LAUNCHER_VERSION}-linux-${ARCH_NAME}.tar.gz -C /usr/local/bin && \
    cd / && rm -rf /launcher-temp

# Copy the entrypoint for Pterodactyl
COPY --chown=container:container ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set permissions and shell
RUN mkdir /home/container/.n8n && chown container:container /home/container/.n8n
WORKDIR /home/container
USER container
ENV SHELL=/bin/sh
STOPSIGNAL SIGINT
ENTRYPOINT ["/usr/bin/tini", "-g", "--"]
CMD ["/entrypoint.sh"]