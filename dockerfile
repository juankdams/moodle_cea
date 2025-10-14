# Usamos la versión estable y moderna 8.3 de PHP
FROM php:8.3-apache

# 1. INSTALAR DEPENDENCIAS DEL SISTEMA
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libzip-dev \
    libxml2-dev \
    libicu-dev \
    zlib1g-dev \
    libcurl4-openssl-dev \
    ghostscript \
    unzip \
    # Añadimos las librerías cliente de MariaDB/MySQL
    default-libmysqlclient-dev \
    && rm -rf /var/lib/apt/lists/*

# 2. INSTALAR EXTENSIONES DE PHP
# --- CAMBIO CLAVE: Añadimos mysqli y pdo_mysql ---
RUN docker-php-ext-install -j$(nproc) gd intl zip soap opcache mysqli pdo_mysql

# 3. COPIAR TU CÓDIGO DE MOODLE
RUN rm -fr /var/www/html/*
COPY . /var/www/html/

# 4. CREAR CARPETA 'moodledata' Y ASIGNAR PERMISOS
RUN mkdir -p /var/www/moodledata && \
    chown -R www-data:www-data /var/www/html && \
    chown -R www-data:www-data /var/www/moodledata
