#!/bin/sh

echo "initialiazing git setup..."

# Parse git-sync vault config for repo details
GIT_CONFIG="/vault/secrets/$GIT_VAULT_SECRET"
REPO_URL=$(grep "^repository:" "$GIT_CONFIG" | sed "s/repository: *['\"]*//" | sed "s/['\"].*//")
GIT_USER=$(grep "^user:" "$GIT_CONFIG" | sed "s/user: *['\"]*//" | sed "s/['\"].*//")
GIT_PASS=$(grep "^password:" "$GIT_CONFIG" | sed "s/password: *['\"]*//" | sed "s/['\"].*//")

# Build authenticated URL
AUTH_URL=$(echo "$REPO_URL" | sed "s|https://|https://${GIT_USER}:${GIT_PASS}@|")

# Clean user directory and clone repo directly (avoids git-sync merge conflicts)
cd /var/www/html/user
rm -rf .git ./* ./.[!.]* 2>/dev/null
git clone --branch ${HEAD_BRANCH:-main} "$AUTH_URL" .
echo "done"

# Create symlinks to vault secrets (after clone so they don't get overwritten)
mkdir -p /var/www/html/user/config/plugins
ln -sf "/vault/secrets/$GIT_VAULT_SECRET" /var/www/html/user/config/plugins/git-sync.yaml
mkdir -p /var/www/html/user/config
ln -sf /vault/secrets/salt /var/www/html/user/config/security.yaml

if [ ! -f "/var/www/html/user/accounts/admin.yaml" ]; then
  echo "Creating admin user..."
  cp "/vault/secrets/$ADMIN_VAULT_SECRET" /var/www/html/user/accounts/admin.yaml
  echo "Admin user created."
fi

echo "Creating SRE user..."
cp "/vault/secrets/$SRE_VAULT_SECRET" /var/www/html/user/accounts/sre.yaml
echo "SRE user created."

apache2-foreground
