#!/bin/bash

# Install Nginx if not already installed
if ! command -v nginx &> /dev/null; then
    apt-get -y update
    apt-get -y install nginx
fi

# Create necessary directories
mkdir -p /data/web_static/releases/test/
mkdir -p /data/web_static/shared/

# Create a fake HTML file
echo -e "<html>\n  <head>\n  </head>\n  <body>\n    Holberton School\n  </body>\n</html>" > /data/web_static/releases/test/index.html

# Create or recreate symbolic link
if [ -L /data/web_static/current ]; then
    rm /data/web_static/current
fi
ln -sf /data/web_static/releases/test/ /data/web_static/current

# Give ownership of directories to ubuntu user and group
chown -R ubuntu:ubuntu /data/

# Update Nginx configuration
config_file="/etc/nginx/sites-available/default"
sed -i '/^\tlocation \/ {$/a \\n\tlocation \/hbnb_static\/ {\n\t\talias \/data\/web_static\/current\/;\n\t}\n' $config_file

# Restart Nginx
service nginx restart

exit 0
