FROM php:8.2-apache

RUN apt-get update && apt-get install -y \

git \

unzip \

libzip-dev \

&& docker-php-ext-install zip mysqli pdo pdo_mysql \

&& apt-get clean && rm -rf /var/lib/apt/lists/*

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

COPY . .

RUN chown -R www-data:www-data /var/www/html/web/app \

&& chmod -R 775 /var/www/html/web/app

RUN composer install --no-dev --optimize-autoloader

ENV APACHE_DOCUMENT_ROOT /var/www/html/web

RUN sed -ri -e "s!/var/www/html!${APACHE_DOCUMENT_ROOT}!g" /etc/apache2/sites-available/*.conf && \

sed -ri -e "s!/var/www/!${APACHE_DOCUMENT_ROOT}!g" /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

RUN echo "upload_max_filesize = 1024M" >> /usr/local/etc/php/conf.d/uploads.ini \

&& echo "post_max_size = 1024M" >> /usr/local/etc/php/conf.d/uploads.ini \

&& echo "memory_limit = 1536M" >> /usr/local/etc/php/conf.d/uploads.ini \

&& echo "max_execution_time = 600" >> /usr/local/etc/php/conf.d/uploads.ini \

&& echo "max_input_time = 600" >> /usr/local/etc/php/conf.d/uploads.ini

RUN a2enmod rewrite

EXPOSE 80