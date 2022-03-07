FROM php:8-fpm-alpine

ARG UID
ARG GID

ENV UID=${UID}
ENV GID=${GID}

RUN mkdir -p /var/www/html

WORKDIR /var/www/html

RUN addgroup -g ${GID} --system wwwuser
RUN adduser -G wwwuser --system -D -s /bin/sh -u ${UID} wwwuser

COPY php/php.ini /usr/local/etc/php/

RUN sed -i "s/user = www-data/user = wwwuser/g" /usr/local/etc/php-fpm.d/www.conf
RUN sed -i "s/group = www-data/group = wwwuser/g" /usr/local/etc/php-fpm.d/www.conf
RUN echo "php_admin_flag[log_errors] = on" >> /usr/local/etc/php-fpm.d/www.conf

# Installing the required php packages
RUN docker-php-ext-install pdo pdo_mysql opcache

# Installing icu dev
RUN apk add icu-dev

# Configuring and installing php modules
RUN docker-php-ext-configure intl && docker-php-ext-install intl

ENV PHP_OPCACHE_VALIDATE_TIMESTAMPS="0"
ADD php/opcache.ini "$PHP_INI_DIR/conf.d/opcache.ini"

# Downloading and installing redis
RUN mkdir -p /usr/src/php/ext/redis \
    && curl -L https://github.com/phpredis/phpredis/archive/5.3.4.tar.gz | tar xvz -C /usr/src/php/ext/redis --strip 1 \
    && echo 'redis' >> /usr/src/php-available-exts \
    && docker-php-ext-install redis

# Starting php-fpm
CMD ["php-fpm", "-y", "/usr/local/etc/php-fpm.conf", "-R"]