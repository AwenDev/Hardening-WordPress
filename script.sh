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


# 2. Deshabilitar la edición de ficheros desde el panel de administración de WordPress

if ! grep -q "DISALLOW_FILE_EDIT" "$WPCONFIG"; then

    echo "Deshabilitando la edición de archivos desde el panel..."
    sed -i "/\/\* That's all, stop editing! Happy publishing. \*\//i define('DISALLOW_FILE_EDIT', true);" "$WPCONFIG"
    echo "Edición deshabilitada."
else
    echo "La constante está definida."
fi