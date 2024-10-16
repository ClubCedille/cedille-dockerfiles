FROM hashicorp/tfc-agent:1.16

USER root

RUN curl -L https://github.com/siderolabs/omni/releases/download/v0.43.0/omnictl-linux-amd64 -o /usr/local/bin/omnictl
RUN chmod +x /usr/local/bin/omnictl

USER tfc-agent