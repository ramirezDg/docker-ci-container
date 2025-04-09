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
RUN echo "max_execution_time=300" >> /usr/local/etc/php/php.ini && \
    echo "max_input_time=300" >> /usr/local/etc/php/php.ini && \
    echo "memory_limit=512M" >> /usr/local/etc/php/php.ini && \
    echo "post_max_size=128M" >> /usr/local/etc/php/php.ini && \
    echo "output_buffering=On" >> /usr/local/etc/php/php.ini && \
    echo "zlib.output_compression=Off" >> /usr/local/etc/php/php.ini