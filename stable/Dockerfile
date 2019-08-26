ARG LEDGER_VERSION="v3.1.3"

FROM alpine:edge as builder

ARG LEDGER_VERSION
ENV LEDGER_VERSION "${LEDGER_VERSION}"

WORKDIR /build

RUN apk add --no-cache \
    cmake \
    build-base \
    boost-dev \
    gmp-dev \
    mpfr-dev \
    texinfo \
    graphviz \
    doxygen \
    gettext \
    git \
    libstdc++ \
    && git clone --branch "${LEDGER_VERSION}" --depth 1 "https://github.com/ledger/ledger" \
    && cd ledger \
	&& cmake -DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_INSTALL_PREFIX=/usr \
	&& make \
    && make install \
    && rm -rf /var/cache \
    && addgroup ledger \
    && adduser -G ledger -s /bin/sh -D ledger

FROM scratch

COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /lib/ld-musl-x86_64.so.1 /lib/ld-musl-x86_64.so.1
COPY --from=builder /usr/lib64/libledger.so.3 /usr/lib64/libledger.so.3
COPY --from=builder /usr/lib/libboost_filesystem.so.1.69.0 /usr/lib/libboost_filesystem.so.1.69.0
COPY --from=builder	/usr/lib/libstdc++.so.6 /usr/lib/libstdc++.so.6
COPY --from=builder	/usr/lib/libgcc_s.so.1 /usr/lib/libgcc_s.so.1
COPY --from=builder	/usr/lib/libmpfr.so.4 /usr/lib/libmpfr.so.4
COPY --from=builder	/usr/lib/libgmp.so.10 /usr/lib/libgmp.so.10
COPY --from=builder	/usr/lib/libboost_iostreams.so.1.69.0 /usr/lib/libboost_iostreams.so.1.69.0
COPY --from=builder	/usr/lib/libboost_regex.so.1.69.0 /usr/lib/libboost_regex.so.1.69.0
COPY --from=builder	/lib/libz.so.1 /lib/libz.so.1
COPY --from=builder	/usr/lib/libbz2.so.1 /usr/lib/libbz2.so.1
COPY --from=builder	/usr/lib/liblzma.so.5 /usr/lib/liblzma.so.5
COPY --from=builder	/usr/lib/libicui18n.so.64 /usr/lib/libicui18n.so.64
COPY --from=builder	/usr/lib/libicuuc.so.64 /usr/lib/libicuuc.so.64
COPY --from=builder	/usr/lib/libicudata.so.64 /usr/lib/libicudata.so.64
COPY --from=builder /usr/bin/ledger /usr/local/bin/ledger

USER ledger

WORKDIR /home/ledger/data

ENTRYPOINT ["ledger"]

LABEL org.opencontainers.image.title="ledger" \
    org.opencontainers.image.description="ledger in Docker" \ 
    org.opencontainers.image.url="https://github.com/westonsteimel/docker-ledger" \ 
    org.opencontainers.image.source="https://github.com/westonsteimel/docker-ledger" \
    org.opencontainers.image.version="${LEDGER_VERSION}" \
    version="${LEDGER_VERSION}"
