#FROM nginx:stable-alpine
FROM nsommer89/cloudtek:base

RUN apk add --update nginx && rm -rf /var/cache/apk/*

ARG UID
ARG GID

ENV UID=${UID}
ENV GID=${GID}

# Adds the user and group to run nginx as
RUN addgroup -g ${GID} --system wwwuser
RUN adduser -G wwwuser --system -D -s /bin/sh -u ${UID} wwwuser

RUN sed -i "s/user  nginx/user wwwuser/g" /etc/nginx/nginx.conf

# nginx conf
COPY ./nginx/nginx.conf /etc/nginx/nginx.conf

# Copying the nginx.conf file to the container
ADD ./nginx/sites/default.conf /etc/nginx/conf.d/
ADD ./nginx/sites/user.conf /etc/nginx/conf.d/

# Creating the web folder
RUN mkdir -p /var/www/html
RUN mkdir -p /home/nikolaj/public_html
RUN echo "<?php phpinfo();" >> /home/nikolaj/public_html/index.php

#CMD /usr/sbin/nginx -g "daemon off;"
CMD ["nginx", "-g", "daemon off;"]

