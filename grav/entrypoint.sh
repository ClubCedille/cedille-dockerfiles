#!/bin/sh

echo "initialiazing git setup..."
mkdir -p /var/www/html/user/config/plugins
cd /var/www/html/
ln -s "/vault/secrets/$GIT_VAULT_SECRET" "/var/www/html/user/config/plugins/git-sync.yaml"
bin/plugin git-sync init
bin/plugin git-sync sync > /dev/null
cd /var/www/html/user
git pull origin $HEAD_BRANCH
echo "done"

echo "Creating admin user..."
cp "/vault/secrets/$ADMIN_VAULT_SECRET" /var/www/html/user/accounts/admin.yaml
echo done

apache2-foreground