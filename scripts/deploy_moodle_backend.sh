#!/bin/bash

# Para mostrar los comandos que se van ejecutando
set -ex

# Importamos las variables de entorno
source .env

# Creamos la base de datos y el usuario para WordPress
mysql -u root <<< "DROP DATABASE IF EXISTS $MOODLE_DB_NAME"
mysql -u root <<< "CREATE DATABASE $MOODLE_DB_NAME"
mysql -u root <<< "DROP USER IF EXISTS $MOODLE_DB_USER@$FRONTEND_PRIVATE_IP"
mysql -u root <<< "CREATE USER $MOODLE_DB_USER@$FRONTEND_PRIVATE_IP IDENTIFIED BY '$MOODLE_DB_PASS'"
mysql -u root <<< "GRANT ALL PRIVILEGES ON $MOODLE_DB_NAME.* TO $MOODLE_DB_USER@$FRONTEND_PRIVATE_IP"