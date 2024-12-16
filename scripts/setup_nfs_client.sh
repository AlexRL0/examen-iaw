#!/bin/bash

#Para mostrar los comandos que se van ejecutando
set -ex

# Importamos el archivo .env
source .env

#Actualizamos los repositorios
apt update

#Actualizamos los paquetes
apt upgrade -y

# Instalamos el cliente NFS
apt install nfs-common -y

# Montamos el directorio
mount $NFS_SERVER_IP:/var/www/html /var/www/html
mount $NFS_SERVER_IP:/var/moodledata /var/moodledata


# Cambiamos la variable de /etc/fstab
sed -i '$a\172.31.16.137:/var/www/html /var/www/html  nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0' /etc/fstab
sed -i '$a\172.31.28.95:/var/www/moodledata /var/www/moodledata nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0' /etc/fstab