#!/bin/bash 
# Settings for PHP7.1-FPM's pool
FPM_MAX_CHILDREN=10
FPM_START_SERVERS=4
FPM_MIN_SPARE_SERVERS=2
FPM_MAX_SPARE_SERVERS=4
FPM_MAX_REQUESTS=1000

service php7.1-fpm stop
    php_fpm_conf="/etc/php/7.1/fpm/pool.d/www.conf"
    # Limit FPM processes
    sed -i 's/^pm.max_children.*/pm.max_children = '${FPM_MAX_CHILDREN}'/' $php_fpm_conf
    sed -i 's/^pm.start_servers.*/pm.start_servers = '${FPM_START_SERVERS}'/' $php_fpm_conf
    sed -i 's/^pm.min_spare_servers.*/pm.min_spare_servers = '${FPM_MIN_SPARE_SERVERS}'/' $php_fpm_conf
    sed -i 's/^pm.max_spare_servers.*/pm.max_spare_servers = '${FPM_MAX_SPARE_SERVERS}'/' $php_fpm_conf
    sed -i 's/\;pm.max_requests.*/pm.max_requests = '${FPM_MAX_REQUESTS}'/' $php_fpm_conf
    # Change to socket connection for better performance
    sed -i 's/^listen =.*/listen = \/var\/run\/php7.1-fpm.sock/' $php_fpm_conf

#enable the changes 
SPHPFPM="php7.1-fpm"
SNGINX="nginx"

function checkIt()
{
serviceStatus=`ps aux | grep -v grep | grep $1 | wc -l`
if [ $serviceStatus == 0 ]
        then
                echo $1 "is not started...";
                echo "Trying to start service $1" 
                if service $2 start >& /dev/null
                        then
                        echo "Service $1 started succesfully..."
                else
                        echo "Could not start service $1..."
                fi
        else
                echo $1 "good";
        fi;
echo "***********************"
}

checkIt "nginx" $SNGINX
checkIt "php-fpm" $SPHPFPM
# Disable xdebug for php-fpm
sudo phpdismod -s fpm xdebug
