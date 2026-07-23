FROM php:8.3-apache

RUN docker-php-ext-install pdo pdo_mysql

RUN a2dismod mpm_event mpm_worker || true
RUN a2enmod mpm_prefork

COPY . /var/www/html/

EXPOSE 80