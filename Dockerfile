FROM php:8.2-apache

RUN apt-get update && apt-get install -y \
    default-mysql-client \
    && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install pdo_mysql mysqli

# Usar la IP del contenedor
RUN echo "ServerName 0.0.0.0" >> /etc/apache2/apache2.conf

COPY . /var/www/html/
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh && \
    chown -R www-data:www-data /var/www/html/ && \
    chmod -R 755 /var/www/html/

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]