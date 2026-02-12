FROM hashicorp/vault:1.21.3
USER root

RUN mkdir -p /vault/plugins
RUN wget -O /vault/plugins/vault-plugin-secrets-github https://github.com/martinbaillie/vault-plugin-secrets-github/releases/download/v2.0.0/vault-plugin-secrets-github-linux-amd64
RUN chmod +x /vault/plugins/vault-plugin-secrets-github

USER vault