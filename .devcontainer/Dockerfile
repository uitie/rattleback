FROM mcr.microsoft.com/devcontainers/base:bullseye

RUN apt-get -y update \
  && apt-get -y install \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg \
  && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg \
  && echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
  && apt-get -y update && apt-get -y install \
  google-cloud-cli

RUN cd /usr/bin \
  && curl -Lo wizcli https://downloads.wiz.io/wizcli/latest/wizcli-linux-arm64 \
  && chmod +x wizcli \
  && cd /tmp \
  && curl -Lo public_key.asc https://downloads.wiz.io/wizcli/public_key.asc \
  && gpg --import public_key.asc \
  && curl -Lo wizcli-sha256 https://downloads.wiz.io/wizcli/latest/wizcli-linux-arm64-sha256 \
  && curl -Lo wizcli-sha256.sig https://downloads.wiz.io/wizcli/latest/wizcli-linux-arm64-sha256.sig \
  && gpg --verify /tmp/wizcli-sha256.sig /tmp/wizcli-sha256 \
  && cat /tmp/wizcli-sha256 \
  && sha256sum /usr/bin/wizcli \
  && cd /usr/bin \
  && echo "$(cat /tmp/wizcli-sha256) wizcli" | sha256sum --check \
  && ls -la .
