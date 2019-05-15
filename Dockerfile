FROM alpine:edge

RUN apk add --no-cache --repository http://nl.alpinelinux.org/alpine/edge/testing \
    ledger \
    && rm -rf /var/cache \
    && addgroup ledger \
    && adduser -G ledger -s /bin/sh -D ledger

USER ledger

WORKDIR /home/ledger/data

ENTRYPOINT ["ledger"]
