cd /var/www/

# GRAV_SKELETON_URL=https://github.com/getgrav/grav-skeleton-gateway-site/releases/download/1.0.1/grav-skeleton-gateway-site+admin-1.0.1.zip
# THEMES_DIR=/var/www/html/user/themes

# Create the themes directory if it does not exist
[ ! -d "$THEMES_DIR" ] && mkdir -p "$THEMES_DIR"
# Use rsync to copy the initial content
if [ -z "$(ls -A "$THEMES_DIR")" ]; then
    echo " Copying theme..."
    cd /var/www/html/
    wget "$GRAV_SKELETON_URL" -O theme.zip
    unzip theme.zip
    rm theme.zip
    git clone https://github.com/getgrav/grav.git grav
    # Install git-sync plugin    
    bin/gpm install git-sync
    # Configures git-sync plugin
    ln -s /vault/secrets/grav /var/www/html/user/config/plugins/git-sync.yaml
else
    echo "Themes directory is not empty. Skipping copying initial content."
fi

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
    echo "done"
else
    echo "git already initialized, continuing"
fi