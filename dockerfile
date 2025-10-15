# Usamos la imagen oficial de PHP 8.3 con Apache
FROM php:8.3-apache

# Instala las dependencias del sistema necesarias
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
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Instala las extensiones de PHP necesarias para Moodle (exif añadida)
RUN docker-php-ext-install -j$(nproc) gd intl zip soap opcache pgsql pdo_pgsql exif

# Copia el archivo de configuración personalizado de PHP
COPY moodle.ini /usr/local/etc/php/conf.d/moodle-custom.ini

# Limpia el directorio por defecto de Apache
RUN rm -fr /var/www/html/*

# Copia los archivos de Moodle al directorio de Apache
COPY . /var/www/html/

# Crea el directorio moodledata y asigna los permisos correctos
RUN mkdir -p /var/www/moodledata && \
    chown -R www-data:www-data /var/www/html && \
    chown -R www-data:www-data /var/www/moodledata
