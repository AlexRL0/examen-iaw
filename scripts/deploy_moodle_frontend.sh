#!/bin/bash

# Para mostrar los comandos que se van ejecutando
set -ex

# Importamos las variables de entorno
source .env

# Eliminamos descargas previas de moodle
rm -rf /tmp/v4.3.1.zip*

# Eliminamos descargas previas de /var/www/hmtl/*
rm -rf /var/www/html/*

# Descargamos el WP-CLI
wget https://github.com/moodle/moodle/archive/refs/tags/v4.3.1.zip -P /tmp

# Extraemos Moodle
unzip /tmp/v4.3.1.zip -C /tmp

# Movemos Moodle al directorio deseado
mv /tmp/moodle-4.3.1 $MOODLE_DIRECTORY

# Configuramos permisos para apache
chown -R www-data:www-data $MOODLE_DIRECTORY
chmod -R 755 $MOODLE_DIRECTORY