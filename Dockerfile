FROM php:8.2-fpm

RUN apt-get update && apt-get install -y \
    default-mysql-client \
    nginx \
    && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install pdo_mysql mysqli

# Copiar configuración de Nginx
COPY nginx.conf /etc/nginx/sites-available/default

# Copiar archivos de la aplicación
COPY . /var/www/html/

RUN chown -R www-data:www-data /var/www/html/ && \
    chmod -R 755 /var/www/html/

EXPOSE 80

CMD ["sh", "-c", "php-fpm -D && nginx -g 'daemon off;'"]