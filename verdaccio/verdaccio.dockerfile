# Due to a permissions issue when sharing VOLUMES
# on the official node image, I've used mhart/alpine-node:latest
# to run this container as root (not as node user). 

FROM mhart/alpine-node:latest

RUN apk --no-cache add openssl && \
    wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64 && \
    chmod +x /usr/local/bin/dumb-init && \
    apk del openssl && \
    apk --no-cache add ca-certificates wget curl && \
    wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.25-r0/glibc-2.25-r0.apk && \
    apk add glibc-2.25-r0.apk

RUN npm config set unsafe-perm true && \
    apk add --no-cache --virtual .gyp \
        python \
        make \
        g++ \
    && npm install -g verdaccio \
    && apk del .gyp

ENV PORT 4873
ENV PROTOCOL http

EXPOSE $PORT

RUN mkdir -p /verdaccio/storage /verdaccio/conf
VOLUME [ "/verdaccio/conf", "/verdaccio/storage" ]

ENTRYPOINT ["/usr/local/bin/dumb-init", "--"]
CMD verdaccio --config /verdaccio/conf/config.yaml --listen $PROTOCOL://0.0.0.0:${PORT}