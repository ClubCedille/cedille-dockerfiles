#!/bin/sh

if [ -z "$(ls -A /var/www/html/user/.git)" ]; then
    echo "git not initialized, running init script..."
    ln -s "/vault/secrets/$GIT_VAULT_SECRET" "/var/www/html/user/config/plugins/git-sync.yaml"
    bin/plugin git-sync init
    bin/plugin git-sync sync > /dev/null
    cd /var/www/html/user
    git pull origin $HEAD_BRANCH
    echo "done"
else
    echo "git already initialized, continuing"
fi

apache2-foreground