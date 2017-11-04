#!/usr/bin/env bash

# Set timezone
ln -sf  /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

apt-get update
apt-get install -y curl git unzip

# Install MySQL
export DEBIAN_FRONTEND=noninteractive
debconf-set-selections <<< "mysql-server-5.7 mysql-server/root_password password "
debconf-set-selections <<< "mysql-server-5.7 mysql-server/root_password_again password "
apt-get install -y mysql-server-5.7
mv /home/vagrant/my.cnf /etc/my.cnf
systemctl restart mysql
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '';"

# Install php 7.1
add-apt-repository ppa:ondrej/php
apt-get update
apt-get install -y php7.1
apt-get install -y php-pear php7.1-fpm php7.1-mysql php7.1-mbstring php7.1-mcrypt php7.1-xml php7.1-gd php7.1-zip php7.1-curl php7.1-intl php7.1-dev
pecl install xdebug

mkdir -p /vagrant/www/tmp/profile

xdebug= `cat <<EOS
zend_extension=/usr/lib/php/20160303/xdebug.so
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
xdebug.profiler_enable=0
xdebug.profiler_output_dir="/vagrant/www/tmp/profile"
xdebug.max_nesting_level=1000
xdebug.remote_host=192.168.123.1
xdebug.remote_port = 9001
xdebug.idekey = "phpstorm"
EOS`

echo $xdebug >> /etc/php/7.1/fpm/php.ini
echo $xdebug >> /etc/php/7.1/cli/php.ini

cd /tmp
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
chmod +x /usr/local/bin/composer

# Install nginx
systemctl disable apache2
systemctl stop apache2
apt-get install -y nginx
mv /home/vagrant/nginx.conf /etc/nginx/nginx.conf
mv /home/vagrant/app.conf /etc/nginx/sites-enabled/app.conf
rm /etc/nginx/sites-enabled/default
systemctl restart nginx
systemctl enable nginx

# Install Redis
apt-get -y install redis-server

# Install nodejs, npm, yarn
apt-get install -y nodejs npm
npm cache clean
npm install n -g
n 8.9
apt-get purge -y nodejs npm
ln -sf /usr/local/bin/node /usr/bin/node
ln -sf /usr/local/bin/npm /usr/bin/npm
npm install -g yarn
