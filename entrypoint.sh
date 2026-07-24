#!/bin/bash
# Deshabilitar MPMs conflictivos
a2dismod mpm_event mpm_worker 2>/dev/null
a2enmod mpm_prefork

# Iniciar Apache
apache2-foreground