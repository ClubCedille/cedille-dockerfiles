FROM alpine:latest

RUN apk add --no-cache wget unzip rsync git \
    php php-fpm php-cli php-curl php-mbstring php-openssl php-dom php-xml php-json php-phar php-zip

ARG GRAV_SKELETON_URL=https://github.com/getgrav/grav-skeleton-gateway-site/releases/download/1.0.1/grav-skeleton-gateway-site+admin-1.0.1.zip

WORKDIR /initial-content
RUN wget "$GRAV_SKELETON_URL" -O theme.zip \
    && unzip theme.zip \
    && rm theme.zip \ 
    && git clone https://github.com/getgrav/grav.git grav

COPY init.sh /init.sh
RUN chmod +x /init.sh

USER 33
ENTRYPOINT ["/init.sh"]