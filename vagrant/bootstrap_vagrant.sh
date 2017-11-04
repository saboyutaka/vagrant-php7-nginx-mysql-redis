#!/usr/bin/env bash

cd /vagrant/www
if [ ! -f .env ]; then
    cp .env.example .env
fi

composer global require hirak/prestissimo
composer install

# mysql -uroot -e 'CREATE DATABASE IF NOT EXISTS app_development;'
# php artisan migrate
# php artisan db:seed
# yarn install
# yarn run dev
