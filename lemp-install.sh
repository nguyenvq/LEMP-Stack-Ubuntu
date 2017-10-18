#!/bin/bash
scriptPath=$PWD

# add php7 and nginx repos
sudo add-apt-repository -y ppa:nginx/development
sudo add-apt-repository -y ppa:ondrej/php
sudo apt-get update
# install basics
sudo apt-get install -y git tmux vim curl wget zip unzip htop
# Nginx
echo "Installing Nginx"
sudo apt-get install -y nginx
# PHP
echo "Installing PHP 7.1"
sudo apt-get install -y php7.1-fpm php7.1-cli php7.1-mcrypt php7.1-gd php7.1-mysql php7.1-pgsql php7.1-imap php-memcached php7.1-mbstring php7.1-xml php7.1-curl php7.1-bcmath php7.1-sqlite3 php7.1-xdebug
# Composer
echo "Installing Composer"
php -r "readfile('http://getcomposer.org/installer');" | sudo php -- --install-dir=/usr/bin/ --filename=composer
echo "Installing Laravel into /var/www"
#getting a Laravel application up and running:
echo "Installing Laravel application into /var/www/myapp"
cd /var/www
sudo composer create-project laravel/laravel:dev-develop myapp
echo "Configuring Nginx for Laravel myapp "
touch /etc/nginx/sites-available/default
echo '
server {
    listen 80 default_server;

    root /var/www/myapp/public;

    index index.html index.htm index.php;

    server_name _;

    location / {
        try_files $uri $uri/ /index.php$is_args$args;
    }

    location ~ \.php$ {
       include snippets/fastcgi-php.conf;
       fastcgi_pass unix:/var/run/php/php7.1-fpm.sock;
    }
}
' > /etc/nginx/sites-available/default
chown -R www-data: /var/www/myapp/storage /var/www/myapp/bootstrap
#Restart Nginx
    service nginx restart
############### Setting for PHP
echo "Setting php "
bash $scriptPath/config-php71.sh
echo "Installing Redis"
bash $scriptPath/install-redis.sh
echo "Installinh Mysql "
bash $scriptPath/config-mysql.sh

