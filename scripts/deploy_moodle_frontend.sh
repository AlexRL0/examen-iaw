#!/bin/bash

# Para mostrar los comandos que se van ejecutando
set -ex

# Importamos las variables de entorno
source .env

# Eliminamos descargas previas de Moodle
rm -rf /tmp/v4.3.1.zip
rm -rf /var/www/html/*
rm -rf /var/moodledata/*

# Cambiamos el propietario y el grupo al directorio /var/www/html/ y moodledata
sudo chown -R www-data:www-data /var/www/html
sudo chmod -R 755 /var/www/html
sudo chown -R www-data:www-data /var/moodledata
sudo chmod -R 755 /var/moodledata

#Configuramos las variables max_input_vars
sed -i "s/;max_input_vars = 1000/max_input_vars = 5000/" /etc/php/8.3/apache2/php.ini
sed -i "s/;max_input_vars = 1000/max_input_vars = 5000/" /etc/php/8.3/cli/php.ini

# Descargamos el WP-CLI
wget https://github.com/moodle/moodle/archive/refs/tags/v4.3.1.zip -P /tmp

# Descomprimimos el archivo en nuestro directorio raíz
sudo unzip /tmp/v4.3.1.zip -d /tmp
mv /tmp/moodle-4.3.1/* /var/www/html

#Instalación automática
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

#Configurar config.php para poner el proxy inverso
sed -i "/\$CFG->admin/a \$CFG->reverseproxy=1;\n\$CFG->sslproxy=1;" /var/www/html/config.php
