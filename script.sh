#!/bin/bash

# 1. Configurar las claves de seguridad de Wordpress (Keys y Salt)

WPCONFIG="C:\xampp\htdocs\wordpress\wp-config.php" # esta ruta habría que sustituirla por la de linux, es la mía actualmente de windows


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

WPCONFIG="C:\xampp\htdocs\wordpress\wp-config.php" # esta ruta habría que sustituirla por la de linux, es la mía actualmente de windows

if ! grep -q "DISALLOW_FILE_EDIT" "$WPCONFIG"; then

    echo "Deshabilitando la edición de archivos desde el panel..."
    sed -i "/\/\* That's all, stop editing! Happy publishing. \*\//i define('DISALLOW_FILE_EDIT', true);" "$WPCONFIG"
    echo "Edición deshabilitada."
else
    echo "La constante está definida."
fi

# 3. Modificar los permisos de los archivos y directorios. Los archivos deben ponerse a 644 y los directorios a 755

cd "C:\xampp\htdocs\wordpress\wp-config.php" # esta ruta habría que sustituirla por la de linux, es la mía actualmente de windows

# Permisos de los archivos
find . -type f -exec chmod 644 {} \;

# Permisos de los directorios
find . -type d -exec chmod 755 {} \;



# 4. Bloquear la ejecución de código PHP en los siguientes directorios: wp-content/uploads, wp-content/plugins y wp-content/themes


for dir in wp-content/uploads wp-content/plugins wp-content/themes; do
  archivo="$dir/.htaccess"

  echo '<FilesMatch "\.php$">
  Deny from all
</FilesMatch>' > "$archivo"

  echo ".htaccess creado o sobrescrito en $dir"
done


### 5. Desactivar el acceso al archivo xmlrpc.php con reglas en un archivo .htaccess

archivo=".htaccess" # aquí se cambia por la ruta del archivo

# Comprobamos si el archivo .htaccess ya existe
if [ ! -f "$archivo" ]; then
    touch "$archivo"
fi

# Se añaden reglas
if ! grep -q "xmlrpc.php" "$archivo"; then
    cat <<EOL >> "$archivo"

<Files xmlrpc.php>
    Order Deny,Allow
    Deny from all
</Files>
EOL
    echo "bloqueado correctamente."
else
    echo "Las reglas ya estaban aplicadas."
fi