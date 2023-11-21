#!/bin/sh
# copy-theme.sh

THEMES_DIR=/var/www/html/user/themes

echo " Copying theme..."

# Create the themes directory if it does not exist
[ ! -d "$THEMES_DIR" ] && mkdir -p "$THEMES_DIR"

# Use rsync to copy the initial content
if [ -z "$(ls -A "$THEMES_DIR")" ]; then
    rsync -av /initial-content/ /var/www/html/
    # Change ownership of the copied content to www-data
    chown -R 33:33 /var/www/html
    # Install git-sync plugin
    cd /var/www/html
    bin/gpm install git-sync
    # Configures git-sync plugin 
    ln -s /vault/secrets/grav /var/www/html/user/config/plugins/git-sync.yaml
else
    echo "Themes directory is not empty. Skipping copying initial content."
fi



