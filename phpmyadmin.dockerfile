FROM phpmyadmin/phpmyadmin

ARG UID
ARG GID

ENV UID=${UID}
ENV GID=${GID}

# Adding pma config file to docker container
ADD ./phpmyadmin/config.user.inc.php /etc/phpmyadmin/config.user.inc.php