#!/bin/bash

#Para mostrar los comandos que se van ejecutando
set -ex

# Importamos el archivo .env
source .env

#Actualizamos los repositorios
apt update

#Actualizamos los paquetes
apt upgrade -y

# Instalamos el servidor NFS
apt install nfs-kernel-server -y

# hacemos el directorio
mkdir -p /var/www/html
mkdir -p /var/moodledata

# Modificamos el grupo y el propietario del directorio
chown nobody:nogroup /var/www/html
chown nobody:nogroup /var/moodledata

# copiamos la plantilla exports a /etc/exports
cp ../nfs/exports /etc/exports

# Reemplazamos el valor de la plantilla de /etc/exports
sed -i "s#FRONTEND_NETWORK#$FRONTEND_NETWORK#" /etc/exports

# Reiniciamos el servicio de NFS
systemctl restart nfs-kernel-server