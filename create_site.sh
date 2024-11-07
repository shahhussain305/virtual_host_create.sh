#!/bin/bash

# Define the domain name as a variable
DOMAIN="sps.com"

# Create the necessary directories
sudo mkdir -p /var/www/$DOMAIN/public_html
sudo chmod -R 755 /var/www/$DOMAIN/public_html
sudo chown -R $USER:$USER /var/www/$DOMAIN/public_html

# Copy the default configuration file
sudo cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/$DOMAIN.conf

# Write the VirtualHost configuration
sudo tee /etc/apache2/sites-available/$DOMAIN.conf > /dev/null <<EOL
<VirtualHost *:80>
    <Directory /var/www/$DOMAIN/public_html>
        Options Indexes FollowSymLinks MultiViews
        AllowOverride All
        Require all granted
    </Directory>

    ServerAdmin shahhussain305@gmail.com
    ServerName $DOMAIN
    ServerAlias www.$DOMAIN
    DocumentRoot /var/www/$DOMAIN/public_html

    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOL

# Enable the virtual host
sudo a2ensite $DOMAIN.conf

# Test Apache configuration for syntax errors
sudo apache2ctl configtest

# Enable rewrite mode (for first time only)
# sudo a2enmode rewrite

# Reload Apache to apply the changes
sudo systemctl reload apache2

# Add entry to /etc/hosts
if ! grep -q "127.0.0.1 $DOMAIN" /etc/hosts; then
    echo "127.0.0.1 $DOMAIN www.$DOMAIN" | sudo tee -a /etc/hosts > /dev/null
    echo "Entry added to /etc/hosts for $DOMAIN"
else
    echo "Entry for $DOMAIN already exists in /etc/hosts"
fi

