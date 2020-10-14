FROM php:7-fpm

LABEL maintainer="Benjamin Kübler <benjamin@kuebler.email>"

WORKDIR /var/www/public

###############################################################################
# Setup Composer                                                              #
###############################################################################

# Install Packages
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        --no-install-recommends \
        git \
        openssh-client \
        unzip \
        && rm -rf /var/lib/apt/lists/*

# Register the COMPOSER_HOME environment variable
ENV COMPOSER_HOME /composer

# Add global binary directory to PATH and make sure to re-export it
ENV PATH /composer/vendor/bin:$PATH

# Allow Composer to be run as root
ENV COMPOSER_ALLOW_SUPERUSER 1

# Setup the Composer installer
RUN curl -s -o /tmp/composer-setup.php https://getcomposer.org/installer \
    && curl -s -o /tmp/composer-setup.sig https://composer.github.io/installer.sig \
    && php -r "if (hash('SHA384', file_get_contents('/tmp/composer-setup.php')) !== trim(file_get_contents('/tmp/composer-setup.sig'))) { unlink('/tmp/composer-setup.php'); echo 'Invalid installer' . PHP_EOL; exit(1); }" \
    && php /tmp/composer-setup.php \
        --no-ansi \
        --install-dir=/usr/local/bin \
        --filename=composer \
    && rm -rf /tmp/composer-setup.php

###############################################################################
# CA Certificates for Secured Connections                                     #
###############################################################################

## If you need additional Root Certificates into your application for example
## you have some self-signed SSL secured services you want to call from your
## application. Uncomment this and put them here.
# RUN curl -s -o /usr/local/share/ca-certificates/{YOUR CERTIFICATE NAME}.crt http://{YOUR LINK TO YOUR CERTIFICATE} \
#     && update-ca-certificates

###############################################################################
# Health check                                                                #
###############################################################################

# Install cgi-fcgi command for healthcheck
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends libfcgi-bin \
    && rm -rf /var/lib/apt/lists/*

HEALTHCHECK --interval=10s --timeout=3s \
    CMD \
    SCRIPT_NAME=/ping \
    SCRIPT_FILENAME=/ping \
    REQUEST_METHOD=GET \
    cgi-fcgi -bind -connect 127.0.0.1:9000 || exit 1

###############################################################################
# Setup PHP for Laravel                                                       #
###############################################################################

# Install additional PHP extensions
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        --no-install-recommends \
        libzip-dev \
    && docker-php-ext-install -j$(nproc) bcmath pdo_mysql zip \
    && rm -rf /var/lib/apt/lists/*

# Copy composer files first and install composer packages to reduce rebuild overhead
COPY composer.json composer.lock /var/www/
RUN cd /var/www && composer install --no-dev --no-scripts --no-autoloader --quiet

# Copy laravel application into image
COPY . /var/www/

# Change owner of files and directories to www-data
# can replaced with --chown on COPY if support is available on platform
# and finalize image
RUN rm -rf /var/www/docker /var/www/html \
    && chown -Rf www-data:www-data /var/www/ \
    && cd /var/www \
    && composer dump-autoload -o --no-dev --quiet
