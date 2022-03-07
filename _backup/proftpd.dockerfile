FROM nsommer89/cloudtek:base
ENV PROFTPD_VERSION 1.3.6d


# initial user
ARG FTP_GROUP
ARG FTP_UID
ARG FTP_USER
ARG FTP_PASS

RUN addgroup -g ${FTP_UID} ftpusers

#RUN ./adduser ${FTP_USER} ${FTP_PASS} ${FTP_UID}

RUN adduser \
    -u ${FTP_UID} \
    -G ${FTP_GROUP} \
    -h /home/${FTP_USER} \
    -D ${FTP_USER} \
    && mkdir -p -v /home/${FTP_USER} \
    && mkdir -p -v /home/${FTP_USER}/public_html \
    && chown -R ${FTP_USER} /home/${FTP_USER} \
    && echo "${FTP_USER}:${FTP_PASS}" | chpasswd

# persistent / runtime deps
ENV PROFTPD_DEPS \
  g++ \
  gcc \
  libc-dev \
  make

RUN set -x \
    && apk add --no-cache --virtual .persistent-deps \
        ca-certificates \
        curl \
    && apk add --no-cache --virtual .build-deps \
        $PROFTPD_DEPS \
    && curl -fSL ftp://ftp.proftpd.org/distrib/source/proftpd-${PROFTPD_VERSION}.tar.gz -o proftpd.tgz \
    && tar -xf proftpd.tgz \
    && rm proftpd.tgz \
    && mkdir -p /usr/local \
    && mv proftpd-${PROFTPD_VERSION} /usr/local/proftpd \
    && sleep 1 \
    && cd /usr/local/proftpd \
    && sed -i 's/__mempcpy/mempcpy/g' lib/pr_fnmatch.c \
    && ./configure \
    && make \
    && cd /usr/local/proftpd && make install \
    && make clean \
    && apk del .build-deps \
    && apk add zsh \
    && sed -i -e "s/bin\/ash/bin\/zsh/" /etc/passwd
    
EXPOSE 20
EXPOSE 21

CMD ["/usr/local/sbin/proftpd", "-n", "-c", "/usr/local/etc/proftpd.conf" ]