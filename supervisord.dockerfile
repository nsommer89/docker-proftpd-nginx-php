FROM php:8-cli-alpine

# Installing required php packages and updating the system
RUN docker-php-ext-install pdo_mysql pcntl \
    && apk update

# Installing supervisord
COPY --from=ochinchina/supervisord:latest /usr/local/bin/supervisord /usr/local/bin/supervisord

# Copy supervisord.conf to the container
ADD ./supervisord/supervisord.conf /etc/

# Starting supervisord
CMD ["supervisord", "-c", "/etc/supervisord.conf"]