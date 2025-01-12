FROM hashicorp/tfc-agent:1.16

USER root

RUN apt-get update && \
  apt-get install -y \
  git \
  openssl \
  unzip \
  zip \
  jq \
  wget \
  gettext-base \
  && rm -rf /var/lib/apt/lists/*

RUN curl -L https://github.com/siderolabs/omni/releases/download/v0.43.0/omnictl-linux-amd64 -o /usr/local/bin/omnictl
RUN chmod +x /usr/local/bin/omnictl

RUN wget https://github.com/mikefarah/yq/releases/download/v4.45.1/yq_linux_amd64  -O /usr/bin/yq \ 
    && chmod +x /usr/bin/yq

USER tfc-agent
