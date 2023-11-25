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

if [ -z "$(ls -A /var/www/html/user/accounts/admin.yaml)" ]; then
    echo "Creating admin user..."
    ln -s "/vault/secrets/$ADMIN_VAULT_SECRET" /var/www/html/user/accounts/admin.yaml
    echo done
fi

if [ -z "$(ls -A /var/www/html/user/config/system.yaml)" ]; then
    echo "creating default config..."
    echo <<EOF > /var/www/html/user/config/system.yaml
home:
  alias: '/home'

pages:
  theme: $DEFAULT_THEME
  process:
    markdown: true
    twig: false
  markdown:
    extra: false

cache:
  enabled: false
  check:
    method: file
  driver: auto
  prefix: 'g'

twig:
  cache: true
  debug: true
  auto_reload: true
  autoescape: false

assets:
  css_pipeline: false
  css_minify: true
  css_rewrite: true
  js_pipeline: false
  js_minify: true

debugger:
  enabled: false
  twig: true
  shutdown:
    close_connection: true
EOF
    echo done
fi

apache2-foreground