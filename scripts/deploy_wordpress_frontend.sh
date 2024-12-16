#!/bin/bash

# Para mostrar los comandos que se van ejecutando
set -ex

# Importamos las variables de entorno
source .env

# Eliminamos descargas previas de WP-CLI
rm -rf /tmp/wp-cli.phar

# Descargamos el WP-CLI
wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -P /tmp

# Le asignamos permisos de ejecución
chmod +x /tmp/wp-cli.phar

# Movemos el script WP-CLI al directorio /usr/local/bin
sudo mv /tmp/wp-cli.phar /usr/local/bin/wp

# Eliminamos instalaciones previas en /var/www/html
rm -rf ${WORDPRESS_DIRECTORY}/*

# Descargamos el código fuente de WordPress
wp core download --locale=es_ES --path=$WORDPRESS_DIRECTORY --allow-root

# Creamos el archivo de configuración de WordPress
wp config create --dbname=$WORDPRESS_DB_NAME --dbuser=$WORDPRESS_DB_USER --dbpass=$WORDPRESS_DB_PASSWORD --dbhost=$WORDPRESS_DB_HOST --path=$WORDPRESS_DIRECTORY --allow-root

# Instalamos WordPress
wp core install --url=$LE_DOMAIN --title=$WORDPRESS_TITULO --admin_user=$WORDPRESS_USUARIO_ADMIN --admin_password=$WORDPRESS_CONTRA_ADMIN --admin_email=$WORDPRESS_EMAIL_ADMIN --path=$WORDPRESS_DIRECTORY --allow-root

# Instalamos y activamos el theme mindscape
wp theme install mindscape --activate --path=$WORDPRESS_DIRECTORY --allow-root

# Instalamos un plugin
wp plugin install wps-hide-login --activate --path=$WORDPRESS_DIRECTORY --allow-root

# Configuramos el plugin de WHL
wp option update whl_page "$WORDPRESS_HIDE_LOGIN_URL" --path=$WORDPRESS_DIRECTORY --allow-root

# Configuramos los enlaces permanentes
wp rewrite structure '/%postname%/' --path=$WORDPRESS_DIRECTORY --allow-root

# Copiamos el archivo .htaccess
cp ../htaccess/.htaccess $WORDPRESS_DIRECTORY

# Cambiamos el propietario y el grupo al directorio /var/www/html/
chown -R www-data:www-data /var/www/html/