#!/bin/sh
# copy-theme.sh

THEMES_DIR=/var/www/html/user/themes

# Function to check if Grav is ready
is_grav_ready() {
    [ -d /var/www/html/grav ]
}

# Wait for Grav to be ready
while ! is_grav_ready; do
    echo "Waiting for Grav to be ready..."
    sleep 10
done

echo "Grav is ready. Copying theme..."

# Create the themes directory if it does not exist
[ ! -d "$THEMES_DIR" ] && mkdir -p "$THEMES_DIR"

# Use rsync to copy the initial content
if [ -z "$(ls -A "$THEMES_DIR")" ]; then
    rsync -av /initial-content/ /var/www/html/
    # Change ownership of the copied content to www-data
    chown -R 33:33 /var/www/html
else
    echo "Themes directory is not empty. Skipping copying initial content."
fi


