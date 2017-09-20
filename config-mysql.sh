#!/bin/bash
# Settings for MySQL 5.7
# Root password for MySQL
DB_ROOT_PASSWORD=`</dev/urandom tr -dc '1234567890!@#$%qwertQWERTasdfgASDFGzxcvbZXCVB'| (head -c $1 > /dev/null 2>&1 || head -c 20)`
DB_NAME=`</dev/urandom tr -dc a-z0-9| (head -c $1 > /dev/null 2>&1 || head -c 8)`
DB_USER=`</dev/urandom tr -dc a-z0-9| (head -c $1 > /dev/null 2>&1 || head -c 8)`
DB_PASSWORD=`</dev/urandom tr -dc A-Za-z0-9| (head -c $1 > /dev/null 2>&1 || head -c 20)`
DB_HOSTNAME='localhost'
DB_PORT='3306'
echo ""
CONFIG_DIR=$PWD
#Setup settings.txt for MySQL
    sed -i "s/DB_NAME/$DB_NAME/"  $CONFIG_DIR/settings.txt
    sed -i "s/DB_USER/$DB_USER/" $CONFIG_DIR/settings.txt
    sed -i "s/DB_PASSWORD/$DB_PASSWORD/" $CONFIG_DIR/settings.txt
    sed -i "s/DB_HOSTNAME/$DB_HOSTNAME/" $CONFIG_DIR/settings.txt
    sed -i "s/DB_PORT/$DB_PORT/" $CONFIG_DIR/settings.txt

function install_mysql () {
sudo apt-get install -y mysql-server
echo -e "\033[35;1m Securing MySQL... \033[0m"
    sleep 5
    sudo apt install expect
    sleep 15
    SECURE_MYSQL=$(expect -c "
        set timeout 10
        spawn mysql_secure_installation
        expect \"Enter current password for root (enter for none):\"
        send \"$DB_ROOT_PASSWORD\r\"
        expect \"Change the root password?\"
        send \"n\r\"
        expect \"Remove anonymous users?\"
        send \"y\r\"
        expect \"Disallow root login remotely?\"
        send \"y\r\"
        expect \"Remove test database and access to it?\"
        send \"y\r\"
        expect \"Reload privilege tables now?\"
        send \"y\r\"
        expect eof
    ")

    echo "$SECURE_MYSQL"
    sudo apt purge expect 
  } # End function install_mysql

function create_db () {
  /usr/bin/mysqladmin -u root -p $DB_ROOT_PASSWORD create database $DB_NAME charset utf8mb4;
  /usr/bin/mysqladmin -u root -p $DB_ROOT_PASSWORD create user $DB_USER@$DB_HOSTNAME identified by $DB_PASSWORD;
  /usr/bin/mysqladmin -u root -p $DB_ROOT_PASSWORD grant all privileges on $DB_NAME.* to $DB_USER@$DB_HOSTNAME;
  /usr/bin/mysqladmin -u root -p $DB_ROOT_PASSWORD flush privileges ;

}

cd /var/www/myapp
php artisan make:auth
php artisan migrate
