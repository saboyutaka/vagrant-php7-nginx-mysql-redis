#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y curl git unzip

# install mysql
debconf-set-selections <<< "mysql-server-5.6 mysql-server/root_password password "
debconf-set-selections <<< "mysql-server-5.6 mysql-server/root_password_again password "
apt-get install -y libmysqlclient-dev mysql-server-5.6 mysql-client-5.6
cat >> /etc/mysql/my.cnf << EOS
[client]
default-character-set = utf8

[mysqld]
skip-character-set-client-handshake
character-set-server  = utf8
collation-server      = utf8_general_ci
init-connect          = SET NAMES utf8
EOS
service mysql restart

# install php7.1
add-apt-repository ppa:ondrej/php -y
apt-get update
apt-get install -y php7.1 php-cli php-pear php-mbstring php7.1-intl php7.1-mysql php7.1-fpm php7.1-dev php7.1-zip
pecl install xdebug

cat >> /etc/php/7.1/fpm/php.ini <<EOS
zend_extension=/usr/lib/php/20160303/xdebug.so
; see http://xdebug.org/docs/all_settings
html_errors=on
xdebug.collect_vars=on
xdebug.collect_params=4
xdebug.dump_globals=on
xdebug.dump.GET=*
xdebug.dump.POST=*
xdebug.show_local_vars=on
xdebug.remote_enable = on
xdebug.remote_autostart=on
xdebug.remote_handler = dbgp
xdebug.remote_connect_back=on
xdebug.profiler_enable=on
xdebug.profiler_output_dir="/tmp"
xdebug.max_nesting_level=1000
xdebug.remote_host=192.168.100.1
xdebug.remote_port = 9001
xdebug.idekey = "mydebug"
EOS

# install composer
curl -sS https://getcomposer.org/installer -o composer-setup.php
php composer-setup.php --install-dir=/usr/local/bin --filename=composer
rm composer-setup.php

# install nginx
service apache2 stop
rm /etc/init.d/apache2

apt-get install nginx -y
rm /etc/nginx/sites-enabled/default
mv /home/vagrant/app.conf /etc/nginx/conf.d/
service nginx restart

# install redis
 apt-get install -y redis-server
