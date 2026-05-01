#!/bin/bash

# Installing Software
sudo dnf install git curl inkscape gimp -y

# Install Apache
echo "Installing Apache.."
sudo dnf install httpd -y

# Enable and start Apache
echo "Enabling and starting apache.."
sudo systemctl enable httpd
sudo systemctl start httpd

# Configure the firewall settings to allow HTTP and HTTPS connections:
echo "Configuring the firewall settings to allow HTTP and HTTPS connections.."
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https

# Reload the firewall
echo "Reloading the firewall.."
sudo firewall-cmd --reload

# Install MariaDB Database
echo "Installing MariaDB Database..."
sudo dnf install mariadb-server -y
echo "Enabling and starting MariaDB"
sudo systemctl enable mariadb
sudo systemctl start mariadb

# Install PHP
echo "Installing PHP..."
sudo dnf install php php-common php-mysqlnd php-cli php-gettext php-mbstring php-mcrypt php-pear php-curl php-gd php-xml php-bcmath php-zip php-json -y

# Install PHPMyAdmin
echo "Installing PHPMyAdmin..."
sudo dnf install phpmyadmin -y

echo "Restarting Apache web server..."
sudo systemctl restart httpd

# Install VSCode
echo "Importing GPG Keys..."
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo "Adding the repository"
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
echo "Installing VSCode..."
sudo dnf install code -y

#Installing Node & Composer
echo "Installing NodeJS and Composer..."
sudo dnf install nodejs npm composer -y

echo "Installation complete."