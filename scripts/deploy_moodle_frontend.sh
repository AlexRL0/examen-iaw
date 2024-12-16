#!/bin/bash

# Para mostrar los comandos que se van ejecutando
set -ex

# Importamos las variables de entorno
source .env

# Eliminamos descargas previas de moodle
rm -rf /tmp/v4.3.1.zip*

# Eliminamos descargas previas de /var/www/hmtl/*
rm -rf /var/www/html/*

#Descargamos la herramienta unzip
apt install unzip -y

# Descargamos el WP-CLI
wget https://github.com/moodle/moodle/archive/refs/tags/v4.3.1.zip -P /tmp

# Extraemos Moodle
unzip /tmp/v4.3.1.zip -d /tmp

# Movemos Moodle al directorio deseado
mv /tmp/moodle-4.3.1/* $MOODLE_DIRECTORY

# Configuramos permisos para apache
chown -R www-data:www-data $MOODLE_DIRECTORY
chmod -R 755 $MOODLE_DIRECTORY

# Configuramos permisos para apache
chown -R www-data:www-data $MOODLE_DATAROOT
chmod -R 755 $MOODLE_DATAROOT

#Configuramos las variables max_input_vars
sed -i "s/;max_input_vars = 1000/max_input_vars = 5000/" /etc/php/8.3/apache2/php.ini
sed -i "s/;max_input_vars = 1000/max_input_vars = 5000/" /etc/php/8.3/cli/php.ini

#Configuramos moodle
sudo -u www-data php /var/www/html/admin/cli/install.php \
        --lang=$MOODLE_LANG \
        --wwwroot=$MOODLE_WWWROOT \
        --dataroot=$MOODLE_DATAROOT \
        --dbtype=$MOODLE_DB_TYPE \
        --dbhost=$MOODLE_DB_HOST \
        --dbname=$MOODLE_DB_NAME \
        --dbuser=$MOODLE_DB_USER \
        --dbpass=$MOODLE_DB_PASS \
        --fullname="$MOODLE_FULLNAME" \
        --shortname="$MOODLE_SHORTNAME" \
        --summary="$MOODLE_SUMMARY" \
        --adminuser=$MOODLE_ADMIN_USER \
        --adminpass=$MOODLE_ADMIN_PASS \
        --adminemail=$MOODLE_ADMIN_EMAIL \
        --non-interactive \
        --agree-license

#Reescribir URLs en Apache
a2enmod rewrite

#Configuramos las variables del proxy
sed -i "/\$CFG->admin/a \$CFG->reverseproxy=1;\n\$CFG->sslproxy=1;" /var/www/html/config.php

#Reiniciamos apache
Systemctl restart apache2