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

if [ ! -f "/var/www/html/user/accounts/admin.yaml" ]; then
  echo "Creating admin user..."
  cp "/vault/secrets/$ADMIN_VAULT_SECRET" /var/www/html/user/accounts/admin.yaml
  echo done
fi

echo "Creating sre user..."
cp "/vault/secrets/$SRE_VAULT_SECRET" /var/www/html/user/accounts/sre.yaml
echo done

rm /var/www/html/user/config/security.yaml
ln -s /vault/secrets/salt /var/www/html/user/config/security.yaml

apache2-foreground
