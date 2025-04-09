# Local
## FROM php:8.1.17-fpm-alpine
# Server
FROM php:7.4-fpm-alpine

# Instalar dependencias del sistema necesarias para extensiones de PHP
RUN apk add --no-cache \
    libpng-dev \
    libjpeg-turbo-dev \
    libwebp-dev \
    freetype-dev \
    libzip-dev \
    oniguruma-dev \
    bzip2-dev \
    icu-dev \
    zlib-dev \
    curl-dev \
    openssl-dev \
    libxml2-dev \
    g++ \
    make \
    autoconf \
    mysql-client

# Instalar extensiones de PHP necesarias para las dependencias del proyecto
RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp && \
    docker-php-ext-install -j$(nproc) \
    pdo \
    pdo_mysql \
    mysqli \
    gd \
    zip \
    xml \
    mbstring \
    bcmath \
    opcache

# Instalar Composer (para manejar dependencias de PHP)
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Configurar valores de PHP
RUN echo "post_max_size=1024M" >> /usr/local/etc/php/php.ini && \
    echo "upload_max_filesize=1024M" >> /usr/local/etc/php/php.ini && \
    echo "memory_limit=1024M" >> /usr/local/etc/php/php.ini && \
    echo "max_input_time=900" >> /usr/local/etc/php/php.ini && \
    echo "max_execution_time=900" >> /usr/local/etc/php/php.ini && \
    echo "session.save_path=/tmp" >> /usr/local/etc/php/php.ini

# Configurar permisos para my.cnf si existe
RUN if [ -f /etc/mysql/conf.d/my.cnf ]; then chmod 644 /etc/mysql/conf.d/my.cnf; fi