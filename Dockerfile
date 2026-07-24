FROM php:8.2-apache

RUN docker-php-ext-install pdo_mysql mysqli

# Solución más agresiva
RUN apt-get purge -y apache2 && \
    apt-get install -y apache2 && \
    a2dismod mpm_* || true && \
    a2enmod mpm_prefork

COPY . /var/www/html/

EXPOSE 80
CMD ["apache2-foreground"]