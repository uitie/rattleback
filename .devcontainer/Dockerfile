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
