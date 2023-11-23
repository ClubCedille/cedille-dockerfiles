#!/bin/sh

sleep 10

GRAV_SKELETON_URL=https://github.com/getgrav/grav-skeleton-gateway-site/releases/download/1.0.1/grav-skeleton-gateway-site+admin-1.0.1.zip

if [ -z "$(ls -A /var/www/html/user/.git)" ]; then
    echo "git not initialized, running init script..."
    cd /var/www/html/
    wget "$GRAV_SKELETON_URL" -O skeleton.zip
    unzip skeleton.zip
    # Install git-sync plugin
    bin/gpm install git-sync
    cd /var/www/html
    rm /var/www/html/user/config/plugins/git-sync.yaml
    ln -s "/vault/secrets/$GIT_VAULT_SECRET" "/var/www/html/user/config/plugins/git-sync.yaml"
    git config --global --add safe.directory /var/www/html/user
    bin/plugin git-sync init
    cd /var/www/html/user
    DEFAULT_BRANCH="$(git symbolic-ref refs/remotes/origin/HEAD --short)"
    git reset --hard $DEFAULT_BRANCH
    git pull $DEFAULT_BRANCH
    echo "done"
else
    echo "git already initialized, continuing"
fi