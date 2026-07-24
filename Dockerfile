FROM php:8.2-apache

# Instalar dependencias y cliente MySQL
RUN apt-get update && apt-get install -y \
    default-mysql-client \
    && rm -rf /var/lib/apt/lists/*

# Instalar extensiones PHP para MySQL
RUN docker-php-ext-install pdo_mysql mysqli

# SOLUCIÓN PARA EL ERROR AH00534: Forzar solo MPM prefork
RUN a2dismod mpm_event && \
    a2dismod mpm_worker && \
    a2enmod mpm_prefork

# Habilitar mod_rewrite (opcional pero recomendado)
RUN a2enmod rewrite

# Copiar archivos de la aplicación
COPY . /var/www/html/

# Configurar permisos
RUN chown -R www-data:www-data /var/www/html/ && \
    chmod -R 755 /var/www/html/

# Exponer puerto 80 (requerido por Railway)
EXPOSE 80

# Iniciar Apache en primer plano
CMD ["apache2-foreground"]