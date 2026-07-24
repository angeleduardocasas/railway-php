FROM php:8.2-apache

RUN apt-get update && apt-get install -y \
    default-mysql-client \
    && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install pdo_mysql mysqli

# Configuración básica
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf && \
    echo "Listen 80" > /etc/apache2/ports.conf && \
    a2dismod mpm_event mpm_worker 2>/dev/null || true && \
    a2enmod mpm_prefork

COPY . /var/www/html/
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh && \
    chown -R www-data:www-data /var/www/html/ && \
    chmod -R 755 /var/www/html/

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]