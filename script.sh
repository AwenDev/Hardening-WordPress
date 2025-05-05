#!/bin/bash

# 1. Configurar las claves de seguridad de Wordpress (Keys y Salt)

archivo="C:\xampp\htdocs\wordpress\wp-config.php"


# Comprobamos si existe

if [ ! -f "$WPCONFIG" ]; then
    echo "El archivo wp-config.php no se encuentra"
    exit 1
fi

# Si existe entonces generamos las nuevas claves

SALTS=$(curl -s https://api.wordpress.org/secret-key/1.1/salt/)

# y las reemplazamos
sed -i "/AUTH_KEY/,+7c\\
$SALTS
" "$WPCONFIG"

