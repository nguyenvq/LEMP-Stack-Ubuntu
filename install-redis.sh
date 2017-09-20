#!/bin/bash
sudo add-apt-repository -y ppa:chris-lea/redis-server
sudo apt-get update
sudo apt-get install -y redis-server
#redis config
CACHE_DRIVER=redis
SESSION_DRIVER=redis
REDIS_HOST=127.0.0.1
REDIS_PASSWORD=null
REDIS_PORT=6379
# config Laravel
APPDIR=/var/www/myapp
#Setup settings.txt for MySQL
    sed -i "s/CACHE_DRIVER/$CACHE_DRIVER/"  $APPDIR/.env
    sed -i "s/SESSION_DRIVER/$SESSION_DRIVER/" $APPDIR/.env
    sed -i "s/REDIS_HOST/$REDIS_HOST/" $APPDIR/.env
    sed -i "s/REDIS_PASSWORD/$REDIS_PASSWORD/" $APPDIR/.env
    sed -i "s/REDIS_PORT/$REDIS_PORT/" $APPDIR/.env
