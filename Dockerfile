FROM php:8.2-apache

RUN apt-get update && apt-get install -y \
    default-mysql-client \
    && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install pdo_mysql mysqli

# Configurar Apache con todas las variables necesarias
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf && \
    echo "Listen 80" > /etc/apache2/ports.conf && \
    # Definir variables de entorno de Apache
    echo "export APACHE_RUN_USER=www-data" >> /etc/apache2/envvars && \
    echo "export APACHE_RUN_GROUP=www-data" >> /etc/apache2/envvars && \
    echo "export APACHE_PID_FILE=/var/run/apache2/apache2.pid" >> /etc/apache2/envvars && \
    echo "export APACHE_RUN_DIR=/var/run/apache2" >> /etc/apache2/envvars && \
    echo "export APACHE_LOCK_DIR=/var/lock/apache2" >> /etc/apache2/envvars && \
    echo "export APACHE_LOG_DIR=/var/log/apache2" >> /etc/apache2/envvar

# SOLUCIÓN AH00558: Configurar ServerName correctamente
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Asegurar puerto 80
RUN echo "Listen 80" > /etc/apache2/ports.conf

# Configurar MPMs para evitar conflictos
RUN a2dismod mpm_event mpm_worker 2>/dev/null || true && \
    a2enmod mpm_prefork

COPY . /var/www/html/
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh && \
    chown -R www-data:www-data /var/www/html/ && \
    chmod -R 755 /var/www/html/

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]