# Usamos una imagen oficial de PHP con el servidor web Apache
FROM php:8.3-apache

# 1. INSTALAR DEPENDENCIAS DEL SISTEMA
# Actualizamos e instalamos librerías que Moodle necesita
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
RUN docker-php-ext-install -j$(nproc) gd pgsql pdo_pgsql intl zip soap opcache

# 3. COPIAR TU CÓDIGO DE MOODLE
# --- CAMBIO CLAVE ---
# Borramos el contenido de ejemplo de Apache y copiamos explícitamente
# el código de tu repositorio a la carpeta correcta.
RUN rm -fr /var/www/html/*
COPY . /var/www/html/

# 4. CREAR CARPETA 'moodledata' Y ASIGNAR PERMISOS
# --- CAMBIO CLAVE ---
# Nos aseguramos de que los permisos se apliquen a todo el código de Moodle
# y a la carpeta de datos, después de haberlos copiado.
RUN mkdir -p /var/www/moodledata && \
    chown -R www-data:www-data /var/www/html && \
    chown -R www-data:www-data /var/www/moodledata
