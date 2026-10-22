#!/bin/sh

USER_DIR=/var/www/html/user

mkdir -p $USER_DIR/plugins
mkdir -p $USER_DIR/themes
mkdir -p $USER_DIR/accounts
mkdir -p $USER_DIR/config/plugins
mkdir -p $USER_DIR/data

# Clone repo directly into user dir so devs can use git (commit, branch, etc.) from ./content
if [ -n "$CONTENT_REPO" ] && [ ! -d "$USER_DIR/.git" ]; then
  echo "Cloning content from: $CONTENT_REPO"
  git clone "$CONTENT_REPO" /tmp/content-clone
  cp -r /tmp/content-clone/. $USER_DIR/
  rm -rf /tmp/content-clone
  echo "Content cloned successfully"
fi

# Replace vault symlinks with local dummy values so dev works without Vault.
# skip-worktree prevents these from showing as changes / being accidentally committed.
if [ -L "$USER_DIR/config/plugins/git-sync.yaml" ] || [ ! -f "$USER_DIR/config/plugins/git-sync.yaml" ]; then
  echo "Creating local git-sync config (disabled)..."
  rm -f $USER_DIR/config/plugins/git-sync.yaml
  cat > $USER_DIR/config/plugins/git-sync.yaml << 'EOF'
enabled: false
EOF
  git -C $USER_DIR config core.fileMode false
  git -C $USER_DIR update-index --skip-worktree config/plugins/git-sync.yaml 2>/dev/null || true
fi

if [ -L "$USER_DIR/config/security.yaml" ] || [ ! -f "$USER_DIR/config/security.yaml" ]; then
  echo "Creating local security config..."
  rm -f $USER_DIR/config/security.yaml
  cat > $USER_DIR/config/security.yaml << 'EOF'
salt: local-dev-salt-not-for-production
EOF
  git -C $USER_DIR update-index --skip-worktree config/security.yaml 2>/dev/null || true
fi

# Create local admin user
if [ ! -f "$USER_DIR/accounts/admin.yaml" ]; then
  echo "Creating local admin user..."
  cat > $USER_DIR/accounts/admin.yaml << 'EOF'
state: enabled
email: admin@localhost
username: admin
fullname: Local Admin
title: Administrator
access:
  admin:
    login: true
    super: true
  site:
    login: true
password: "admin123"
EOF
  echo "Local admin user created (admin/admin123)"
fi

chown -R www-data:www-data $USER_DIR
chmod -R 777 $USER_DIR
# Restore ownership of repo root and .git to host user so git works without safe.directory config
chown ${HOST_UID:-1000} $USER_DIR
chown -R ${HOST_UID:-1000} $USER_DIR/.git

# Clear Grav cache
cd /var/www/html/
bin/grav cache
echo "Local development ready."

apache2-foreground
