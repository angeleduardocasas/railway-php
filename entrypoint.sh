#!/bin/bash
set -e

echo "=== 🚀 Iniciando Apache ==="

# Verificar configuración
echo "=== Verificando configuración de Apache ==="
apache2 -t

# Verificar puertos
echo "=== Puertos configurados ==="
cat /etc/apache2/ports.conf

# Verificar MPMs cargados
echo "=== MPMs activos ==="
apache2 -M | grep mpm || echo "No se encontraron MPMs"

# Verificar que el puerto 80 esté disponible
echo "=== Verificando puerto 80 ==="
netstat -tlnp 2>/dev/null | grep :80 || echo "Puerto 80 libre"

# Iniciar Apache
echo "=== Iniciando servidor ==="
exec apache2-foreground