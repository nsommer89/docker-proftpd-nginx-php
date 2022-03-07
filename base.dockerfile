FROM alpine

ARG UID
ARG GID

ENV UID=${UID}
ENV GID=${GID}

RUN addgroup -g ${GID} --system wwwuser
RUN adduser -G wwwuser --system -D -s /bin/sh -u ${UID} wwwuser

RUN mkdir -p /scripts

# scripts
COPY scripts/add-user.sh /adduser
RUN sed $'s/\r//' -i /adduser
RUN chmod +x /adduser
COPY scripts/del-user.sh /deluser
RUN sed $'s/\r//' -i /deluser
RUN chmod +x /deluser