#!/bin/bash
# Settings for PHP7.1-FPM's pool
FPM_MAX_CHILDREN=10
FPM_START_SERVERS=4
FPM_MIN_SPARE_SERVERS=2
FPM_MAX_SPARE_SERVERS=4
FPM_MAX_REQUESTS=1000

# Settings for php.ini
PHP_MEMORY_LIMIT=256M
PHP_MAX_EXECUTION_TIME=120
PHP_MAX_INPUT_TIME=300
PHP_POST_MAX_SIZE=25M
PHP_UPLOAD_MAX_FILESIZE=25M

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

function checkProcess()
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

checkProcess "nginx" $SNGINX
checkProcess "php-fpm" $SPHPFPM
# Disable xdebug for php-fpm
sudo phpdismod -s fpm xdebug
sudo service $SPHPFPM reload

php_ini_dir="/etc/php/7.1/fpm/php.ini"
    # Tweak php.ini based on input in options.conf
    sed -i 's/^max_execution_time.*/max_execution_time = '${PHP_MAX_EXECUTION_TIME}'/' $php_ini_dir
    sed -i 's/^memory_limit.*/memory_limit = '${PHP_MEMORY_LIMIT}'/' $php_ini_dir
    sed -i 's/^max_input_time.*/max_input_time = '${PHP_MAX_INPUT_TIME}'/' $php_ini_dir
    sed -i 's/^post_max_size.*/post_max_size = '${PHP_POST_MAX_SIZE}'/' $php_ini_dir
    sed -i 's/^upload_max_filesize.*/upload_max_filesize = '${PHP_UPLOAD_MAX_FILESIZE}'/' $php_ini_dir
    sed -i 's/^expose_php.*/expose_php = Off/' $php_ini_dir
    sed -i 's/^disable_functions.*/disable_functions = exec,system,passthru,shell_exec,escapeshellarg,escapeshellcmd,proc_close,proc_open,dl,popen,show_source/' $php_ini_dir



    echo "All done -enjoy your LAMP-Stack-Ubuntu !"
