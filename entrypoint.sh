#!/bin/bash
set -e

echo "=== Configurando entorno de Apache ==="

# Definir variables de entorno necesarias
export APACHE_RUN_USER=www-data
export APACHE_RUN_GROUP=www-data
export APACHE_PID_FILE=/var/run/apache2/apache2.pid
export APACHE_RUN_DIR=/var/run/apache2
export APACHE_LOCK_DIR=/var/lock/apache2
export APACHE_LOG_DIR=/var/log/apache2

# Crear directorios si no existen
mkdir -p /var/run/apache2 /var/lock/apache2 /var/log/apache2
chown -R www-data:www-data /var/run/apache2 /var/lock/apache2 /var/log/apache2

# Verificar configuración
echo "=== Verificando Apache ==="
apache2 -t

echo "=== Variables de entorno ==="
env | grep APACHE

echo "=== Iniciando Apache ==="
exec apache2-foreground