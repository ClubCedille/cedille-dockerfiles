FROM php:8.4.10-apache-bullseye
LABEL maintainer="Andy Miller <rhuk@getgrav.org> (@rhukster)"


# Enable Apache Rewrite + Expires Module
RUN a2enmod rewrite expires && \
    sed -i 's/ServerTokens OS/ServerTokens ProductOnly/g' \
    /etc/apache2/conf-available/security.conf

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    unzip \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libyaml-dev \
    libzip4 \
    libzip-dev \
    zlib1g-dev \
    libicu-dev \
    g++ \
    git \
    cron \
    vim \
    wget \
    rsync \
    && docker-php-ext-install opcache \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install zip \
    && rm -rf /var/lib/apt/lists/*

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
    echo 'opcache.enable=0'; \
    echo 'opcache.memory_consumption=128'; \
    echo 'opcache.interned_strings_buffer=8'; \
    echo 'opcache.max_accelerated_files=4000'; \
    echo 'opcache.revalidate_freq=2'; \
    echo 'opcache.fast_shutdown=1'; \
    echo 'opcache.enable_cli=1'; \
    echo 'upload_max_filesize=128M'; \
    echo 'post_max_size=128M'; \
    echo 'expose_php=off'; \
    echo 'memory_limit=2048M'; \
    } > /usr/local/etc/php/conf.d/php-recommended.ini

RUN pecl channel-update pecl.php.net

RUN pecl install apcu \
    && pecl install yaml \
    && docker-php-ext-enable apcu yaml

# Set ServerName to localhost to avoid FQDN warning
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf
RUN echo "Listen 8080" > /etc/apache2/ports.conf

# Define Grav specific version of Grav or use latest stable
ARG GRAV_VERSION=1.7.45
ARG GRAV_SKELETON_URL=https://github.com/getgrav/grav/releases/download/$GRAV_VERSION/grav-admin-v$GRAV_VERSION.zip
ARG GRAV_SKELETON_FOLDER=grav-admin
#https://github.com/getgrav/grav-skeleton-gateway-site/releases/download/1.0.1/grav-skeleton-gateway-site+admin-1.0.1.zip

RUN chown www-data:www-data /var/www
# Set user to www-data
USER www-data

# Create cron job for Grav maintenance scripts
RUN crontab \ 
    && (crontab -l; echo "* * * * * cd /var/www/html;/usr/local/bin/php bin/grav scheduler 1>> /dev/null 2>&1") | crontab -

# Init operations
RUN cd /var/www/html/ && \
    wget $GRAV_SKELETON_URL -O skeleton.zip && \
    unzip skeleton.zip && \
    mv $GRAV_SKELETON_FOLDER/* . && mv $GRAV_SKELETON_FOLDER/.* . 2>/dev/null; true && \
    bin/gpm install git-sync && \
    git config --global --add safe.directory /var/www/html/user

# Return to root user
# USER root

# Copy init scripts
COPY entrypoint.sh /entrypoint.sh

# provide container inside image for data persistence
VOLUME ["/var/www/html"]

ENTRYPOINT ["/bin/sh", "/entrypoint.sh"]
# CMD ["apache2-foreground"]
# CMD ["sh", "/entrypoint.sh"]pache2-foregroun
