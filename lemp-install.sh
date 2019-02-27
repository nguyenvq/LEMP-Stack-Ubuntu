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
echo "Installing PHP 7.2"
sudo apt-get install -y php7.2-fpm php7.2-cli php7.2-mcrypt php7.2-gd php7.2-mysql php7.2-pgsql php7.2-imap php-memcached php7.2-mbstring php7.2-xml php7.2-curl php7.2-bcmath php7.2-sqlite3 php7.2-xdebug
# Composer
echo "Installing Composer"
php -r "readfile('http://getcomposer.org/installer');" | sudo php -- --install-dir=/usr/bin/ --filename=composer
echo "Installing Laravel into /var/www"
#getting a Laravel application up and running:
echo "Installing Laravel application into /var/www/myapp"
cd /var/www
sudo composer create-project laravel/laravel:dev-develop myapp
echo "Setting ENV"
cd /var/www/myapp
cp .env.example .env
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
       fastcgi_pass unix:/var/run/php7.2-fpm.sock;
    }
}
' > /etc/nginx/sites-available/default
chown -R www-data: /var/www/myapp/storage /var/www/myapp/bootstrap
#Restart Nginx
    service nginx restart
############### Setting for PHP
echo "Setting php "
/bin/bash $scriptPath/config-php72.sh
sleep 5
echo "Installing Redis"
/bin/bash $scriptPath/install-redis.sh
sleep 5
#echo "Installing Mysql "
#/bin/bash $scriptPath/config-mysql.sh
