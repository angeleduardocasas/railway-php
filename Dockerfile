FROM php:8.2-apache

# Instalar dependencias
RUN apt-get update && apt-get install -y \
    default-mysql-client \
    && rm -rf /var/lib/apt/lists/*

# Instalar extensiones PHP necesarias
RUN docker-php-ext-install pdo_mysql mysqli

# Deshabilitar MPMs conflictivos y habilitar solo prefork
RUN a2dismod mpm_event mpm_worker && \
    a2enmod mpm_prefork

# Copiar archivos de la aplicación
COPY . /var/www/html/

# Configurar permisos
RUN chown -R www-data:www-data /var/www/html/ && \
    chmod -R 755 /var/www/html/

# Exponer puerto
EXPOSE 80

# Iniciar Apache
CMD ["apache2-foreground"]