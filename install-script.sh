#!/bin/bash

set -e

echo "🚀 Starting full system setup..."

export DEBIAN_FRONTEND=noninteractive

# Update system
apt update -y
apt upgrade -y

# Install basic tools
apt install -y software-properties-common curl wget unzip gnupg lsb-release ca-certificates apt-transport-https git

# --------------------------------------------------
# PHP 8.3
# --------------------------------------------------
echo "📦 Installing PHP 8.3..."

add-apt-repository -y ppa:ondrej/php
apt update -y

apt install -y php8.3 php8.3-cli php8.3-fpm php8.3-mysql php8.3-xml php8.3-mbstring php8.3-curl php8.3-zip php8.3-gd php8.3-intl

# Enable PHP module for Apache
a2enmod php

# --------------------------------------------------
# MariaDB (MySQL)
# --------------------------------------------------
echo "📦 Installing MariaDB..."

apt install -y mariadb-server mariadb-client

systemctl enable mariadb
systemctl start mariadb

# Secure MariaDB automatically (basic)
mysql -e "DELETE FROM mysql.user WHERE User='';"
mysql -e "DROP DATABASE IF EXISTS test;"
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'root';"
mysql -e "FLUSH PRIVILEGES;"

# --------------------------------------------------
# Composer (latest)
# --------------------------------------------------
echo "📦 Installing Composer..."

php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php --install-dir=/usr/local/bin --filename=composer
rm composer-setup.php

# --------------------------------------------------
# Node.js (Latest LTS)
# --------------------------------------------------
echo "📦 Installing Node.js..."

curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
apt install -y nodejs

# --------------------------------------------------
# phpMyAdmin (non-interactive)
# --------------------------------------------------
echo "📦 Installing phpMyAdmin..."

echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections
echo "phpmyadmin phpmyadmin/app-password-confirm password root" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/admin-pass password root" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/app-pass password root" | debconf-set-selections
echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | debconf-set-selections

apt install -y phpmyadmin apache2

systemctl enable apache2
systemctl restart apache2

# Ensure PHP module is loaded in Apache
a2enmod php 2>/dev/null || true

# --------------------------------------------------
# Brave Browser
# --------------------------------------------------
echo "📦 Installing Brave Browser..."

sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

sudo curl -fsSLo /etc/apt/sources.list.d/brave-browser-release.sources https://brave-browser-apt-release.s3.brave.com/brave-browser.sources

apt update -y
apt install -y brave-browser

# --------------------------------------------------
# ONLYOFFICE
# --------------------------------------------------
echo "📦 Installing ONLYOFFICE..."

wget -qO - https://download.onlyoffice.com/GPG-KEY-ONLYOFFICE | gpg --dearmor -o /usr/share/keyrings/onlyoffice.gpg

echo "deb [signed-by=/usr/share/keyrings/onlyoffice.gpg] https://download.onlyoffice.com/repo/debian squeeze main" \
| tee /etc/apt/sources.list.d/onlyoffice.list

apt update -y
apt install -y onlyoffice-desktopeditors

# --------------------------------------------------
# GIMP & Inkscape
# --------------------------------------------------
echo "📦 Installing GIMP and Inkscape..."

apt install -y gimp inkscape

# --------------------------------------------------
# Create Guest User (no password)
# --------------------------------------------------
echo "👤 Creating guest user..."

if ! id "guest" &>/dev/null; then
    adduser --disabled-password --gecos "" guest
fi

# Remove password requirement
passwd -d guest

# Optional: auto-login permissions
# usermod -aG sudo guest

echo "✅ Setup completed successfully!"
echo "👉 You can now log in as 'guest' without a password."	
