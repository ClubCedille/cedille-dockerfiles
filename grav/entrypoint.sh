#!/bin/sh

echo "initialiazing git setup..."
mkdir -p /var/www/html/user/config/plugins
cd /var/www/html/

# Use git-sync init to set up repo config (but skip sync to avoid merge conflicts)
ln -sf "/vault/secrets/$GIT_VAULT_SECRET" "/var/www/html/user/config/plugins/git-sync.yaml"
bin/plugin git-sync init

# Fetch and hard reset to remote branch (clean, no merge)
cd /var/www/html/user
git fetch origin
git reset --hard origin/${HEAD_BRANCH:-main}
echo "done"

# Create symlinks to vault secrets (after git reset so they don't get overwritten)
ln -sf "/vault/secrets/$GIT_VAULT_SECRET" /var/www/html/user/config/plugins/git-sync.yaml
mkdir -p /var/www/html/user/config
ln -sf /vault/secrets/salt /var/www/html/user/config/security.yaml

if [ ! -f "/var/www/html/user/accounts/admin.yaml" ]; then
  echo "Creating admin user..."
  cp "/vault/secrets/$ADMIN_VAULT_SECRET" /var/www/html/user/accounts/admin.yaml
  echo done
fi

echo "Creating sre user..."
cp "/vault/secrets/$SRE_VAULT_SECRET" /var/www/html/user/accounts/sre.yaml
echo done

apache2-foreground
