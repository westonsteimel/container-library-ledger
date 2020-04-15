ARG LEDGER_VERSION="master"

FROM alpine:edge as builder

ARG LEDGER_VERSION
ENV LEDGER_VERSION "${LEDGER_VERSION}"

WORKDIR /build

RUN apk add --no-cache \
    cmake \
    build-base \
    boost-dev \
    gmp-dev \
    mpfr4-dev \
    texinfo \
    graphviz \
    doxygen \
    gettext \
    git \
    libstdc++ \
    && git clone --branch "${LEDGER_VERSION}" --depth 1 "https://github.com/ledger/ledger" \
    && cd ledger \
    && ln -s /usr/bin/python3 /usr/bin/python \
	&& cmake . -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_LIBDIR:PATH=lib \
	&& make \
    && make install \
    && rm -rf /var/cache \
    && addgroup ledger \
    && adduser -G ledger -s /bin/sh -D ledger

FROM scratch

ARG LEDGER_VERSION

COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /lib/ld-musl-x86_64.so.1 /lib/
COPY --from=builder /usr/local/lib/libledger.so.* /usr/local/lib/
COPY --from=builder /usr/lib/libboost_filesystem.so.*.*.* /usr/lib/
COPY --from=builder	/usr/lib/libstdc++.so.6 /usr/lib/
COPY --from=builder	/usr/lib/libgcc_s.so.1 /usr/lib/
COPY --from=builder	/usr/lib/libmpfr.so.* /usr/lib/
COPY --from=builder	/usr/lib/libgmp.so.* /usr/lib/
COPY --from=builder	/usr/lib/libboost_iostreams.so.*.*.* /usr/lib/
COPY --from=builder	/usr/lib/libboost_regex.so.*.*.* /usr/lib/
COPY --from=builder	/lib/libz.so.1 /lib/
COPY --from=builder	/usr/lib/libbz2.so.1 /usr/lib/
COPY --from=builder	/usr/lib/liblzma.so.5 /usr/lib/
COPY --from=builder	/usr/lib/libicui18n.so.66 /usr/lib/
COPY --from=builder	/usr/lib/libicuuc.so.66 /usr/lib/
COPY --from=builder	/usr/lib/libicudata.so.66 /usr/lib/
COPY --from=builder /usr/local/bin/ledger /usr/local/bin/ledger

USER ledger

WORKDIR /home/ledger/data

ENTRYPOINT ["ledger"]

LABEL org.opencontainers.image.title="ledger" \
    org.opencontainers.image.description="ledger in Docker" \
    org.opencontainers.image.url="https://github.com/westonsteimel/docker-ledger" \
    org.opencontainers.image.source="https://github.com/westonsteimel/docker-ledger" \
    org.opencontainers.image.version="${LEDGER_VERSION}" \
    version="${LEDGER_VERSION}"

