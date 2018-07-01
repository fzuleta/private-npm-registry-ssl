FROM nginx:latest

ARG DOMAIN
ARG NPM_PORT

COPY ./default_pre.conf /default_pre.conf
COPY ./default.conf /default.conf
COPY ./entrypoint.sh /entrypoint.sh

RUN mkdir /etc/letsencrypt && \
mkdir /data && \
mkdir /data/letsencrypt && \
sed -i "s/@NPM_PORT@/${NPM_PORT}/g" /default.conf && \
sed -i "s/@DOMAIN@/${DOMAIN}/g" /default.conf && \
chmod +x /entrypoint.sh

VOLUME ["/etc/letsencrypt", "/data/letsencrypt"]

CMD [ "/entrypoint.sh" ]