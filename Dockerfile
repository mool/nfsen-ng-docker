# FROM ubuntu:20.04

# RUN apt update && \
  # apt dist-upgrade -y && \
  # DEBIAN_FRONTEND=noninteractive apt install -y apache2 git nfdump pkg-config \
    # php7.4 php7.4-dev libapache2-mod-php7.4 rrdtool librrd-dev

FROM php:7.2-apache

RUN apt update && \
  apt install -y git nfdump rrdtool librrd-dev && \
  a2enmod rewrite deflate headers expires && \
  pecl install rrd && \
  echo "extension=rrd.so" > /usr/local/etc/php/conf.d/rrd.ini && \
  mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" && \
  sed -e '/<Directory \/var\/www\/>/,/<\/Directory>/s/AllowOverride None/AllowOverride All/' -i /etc/apache2/apache2.conf

WORKDIR /var/www/html

RUN git clone https://github.com/mbolli/nfsen-ng . && \
  chown -R www-data:www-data . && \
  chmod +x backend/cli.php

ADD ./settings.php backend/settings/settings.php
