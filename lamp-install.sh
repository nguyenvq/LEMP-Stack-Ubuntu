#!/bin/bash

# First uninstall any unnecessary packages and ensure that aptitude is installed.
# add php7 and nginx repos
sudo add-apt-repository -y ppa:nginx/development
sudo add-apt-repository -y ppa:ondrej/php
sudo apt-get update
sudo apt-get -y install aptitude
sudo aptitude -y install nano
sudo aptitude -y install lsb-release
sudo aptitude -y install vim
sudo service apache2 stop
sudo service sendmail stop
sudo service bind9 stop
sudo service nscd stop
sudo aptitude -y purge nscd bind9 sendmail apache2 apache2.2-common
sudo aptitude -y upgrade
# install basics
sudo apt-get install -y git tmux vim curl wget zip unzip htop
# Nginx
sudo apt-get install -y nginx
# PHP
sudo apt-get install -y php7.1-fpm php7.1-cli php7.1-mcrypt php7.1-gd php7.1-mysql \
       php7.1-pgsql php7.1-imap php-memcached php7.1-mbstring php7.1-xml php7.1-curl \
       php7.1-bcmath php7.1-sqlite3 php7.1-xdebug

# Composer
php -r "readfile('http://getcomposer.org/installer');" | sudo php -- --install-dir=/usr/bin/ --filename=composer
echo "Installing Laravel into /var/www"
cd /var/www
sudo composer create-project laravel/laravel:dev-develop myapp

echo ""
