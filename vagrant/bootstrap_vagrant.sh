#!/usr/bin/env bash

# Install laravel
composer global require "laravel/installer"
echo 'export PATH="$HOME/.config/composer/vendor/bin:$PATH"' >> ~/.bashrc

mkdir -p /vagrant/www/tmp/profile
