# Usamos la imagen oficial de PHP 8.3 con Apache
FROM php:8.3-apache

# Instala las dependencias del sistema necesarias para las extensiones de Moodle
# AÑADIDO: libpq-dev para PostgreSQL
# QUITADO: default-libmysqlclient-dev para MySQL
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

# Instala las extensiones de PHP necesarias para Moodle
# AÑADIDO: pgsql y pdo_pgsql para PostgreSQL
# QUITADO: mysqli y pdo_mysql para MySQL
RUN docker-php-ext-install -j$(nproc) gd intl zip soap opcache pgsql pdo_pgsql

# Limpia el directorio por defecto de Apache
RUN rm -fr /var/www/html/*

# Copia los archivos de Moodle al directorio de Apache
COPY . /var/www/html/

# Crea el directorio moodledata y asigna los permisos correctos
RUN mkdir -p /var/www/moodledata && \
    chown -R www-data:www-data /var/www/html && \
    chown -R www-data:www-data /var/www/moodledata
