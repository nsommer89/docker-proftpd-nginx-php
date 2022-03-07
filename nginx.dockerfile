FROM nsommer89/cloudtek:base

RUN apk add --update nginx && rm -rf /var/cache/apk/*

# nginx conf
COPY ./nginx/nginx.conf /etc/nginx/nginx.conf

RUN sed -i "s/user  nginx/user wwwuser/g" /etc/nginx/nginx.conf

# Copying the nginx.conf file to the container
ADD ./nginx/sites/default.conf /etc/nginx/conf.d/

# Creating the web folder
RUN mkdir -p /var/www/html
RUN mkdir -p /home/nikolaj/public_html
RUN echo "<?php phpinfo();" >> /home/nikolaj/public_html/index.php

CMD ["nginx", "-g", "daemon off;"]