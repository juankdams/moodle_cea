# Usamos una imagen oficial de PHP con el servidor web Apache ya incluido
FROM php:8.1-apache

# Variables de entorno para Moodle
ENV MOODLE_HOME /var/www/html
WORKDIR $MOODLE_HOME

# 1. INSTALAR DEPENDENCIAS DEL SISTEMA
# Actualizamos el sistema e instalamos herramientas y librerías que Moodle necesita
# (para procesar imágenes, conectar a la base de datos, etc.)
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libpq-dev \
    libzip-dev \
    libxml2-dev \
    libicu-dev \
    zlib1g-dev \
    libcurl4-openssl-dev \
    ghostscript \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# 2. INSTALAR EXTENSIONES DE PHP
# Moodle necesita un montón de extensiones de PHP. Este comando las instala.
RUN docker-php-ext-install -j$(nproc) gd pgsql pdo_pgsql intl zip soap opcache

# 3. COPIAR TU CÓDIGO DE MOODLE
# Copiamos todo el código de tu repositorio a la carpeta del servidor web dentro del contenedor
COPY . .

# 4. CREAR LA CARPETA 'moodledata' Y ASIGNAR PERMISOS
# Creamos la carpeta donde Moodle guarda los archivos de los cursos
# y nos aseguramos de que el servidor web (www-data) tenga permiso para escribir en ella.
RUN mkdir -p /var/www/moodledata && \
    chown -R www-data:www-data /var/www/moodledata && \
    chown -R www-data:www-data $MOODLE_HOME

# El servidor Apache ya está configurado para ejecutarse por defecto en esta imagen base
