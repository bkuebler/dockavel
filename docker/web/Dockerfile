FROM nginx:latest

LABEL maintainer="Benjamin Kübler <benjamin@kuebler.email>"

###############################################################################
# Health check                                                                #
###############################################################################

# Install cgi-fcgi command for healthcheck
RUN apt-get update \
    && apt-get install -y --no-install-recommends curl \
    && rm -rf /var/lib/apt/lists/*

HEALTHCHECK --interval=10s --timeout=3s \
    CMD \
    curl -f http://localhost/nginx/health || exit 1

###############################################################################
# NGINX setup                                                                 #
###############################################################################

# add nginx configuration to image
COPY docker/web/default.conf /etc/nginx/conf.d/default.conf

# generate self-signed cert
RUN [ "/bin/bash", "-c", "openssl req -x509 -out /etc/nginx/server.crt -keyout /etc/nginx/server.key -newkey \
    rsa:2048 -nodes -sha256 -subj '/CN=localhost' -extensions EXT \
    -config <( printf '[dn]\nCN=localhost\n[req]\ndistinguished_name = dn\n[EXT]\nsubjectAltName=DNS:localhost\nkeyUsage=digitalSignature\nextendedKeyUsage=serverAuth') 2>/dev/null" ]

# copy public directory with static files for laravel to image
COPY public /var/www/public

# Change owner of files and directories to root
# can replaced with --chown on COPY if support is available on platform
RUN chown -Rf root:root /var/www/public
