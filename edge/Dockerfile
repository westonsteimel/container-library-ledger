ARG VERSION="master"
ARG REVISION="42a2121a9d19112e6f34b612f81f40a8eaf1cf4e"

FROM alpine:latest as builder

ARG VERSION
ARG REVISION

WORKDIR /build

RUN apk add --no-cache \
    cmake \
    build-base \
    boost-dev \
    boost-static \
    gmp-dev \
    mpfr-dev \
    texinfo \
    graphviz \
    doxygen \
    gettext \
    git \
    libstdc++ \
    icu-static \
    icu-dev \
    icu-data-en \
    libbz2 \
    bzip2-static \
    bzip2-dev \
    zlib-static \
    zlib-dev \
    xz-static \
    xz-dev \
    && git clone --branch "${VERSION}" "https://github.com/ledger/ledger" \
    && cd ledger \
    && git checkout "${REVISION}"

RUN cd ledger \
    && cmake . -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_LIBDIR:PATH=lib \
    -DBUILD_SHARED_LIBS=OFF \
    -DBUILD_LIBRARY=OFF \
    -DUSE_PYTHON=OFF \
	-DCMAKE_FIND_LIBRARY_SUFFIXES=".a" \
    -DCMAKE_EXE_LINKER_FLAGS="-static -static-libstdc++ -static-libgcc" \
    -DBoost_USE_STATIC_LIBS=ON \
    && make \
    && make install \
    && rm -rf /var/cache \
    && strip /usr/local/bin/ledger \
    && if [$TARGETPLATFORM = "linux/amd64"]; then apk add --no-cache upx && upx --lzma --best /usr/local/bin/ledger; fi \
    && addgroup ledger \
    && adduser -G ledger -s /bin/sh -D ledger

FROM scratch

ARG VERSION
ARG REVISION
ENV LEDGER_VERSION="${VERSION}" \
    LEDGER_REVISION="${REVISION}"

COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /lib/ld-musl-x86_64.so.1 /lib/
COPY --from=builder /usr/local/bin/ledger /usr/local/bin/ledger
COPY --from=builder /usr/share/icu /usr/share/icu

USER ledger

WORKDIR /home/ledger/data

ENTRYPOINT ["ledger"]

LABEL org.opencontainers.image.title="ledger" \
    org.opencontainers.image.description="ledger in Docker" \
    org.opencontainers.image.revision="${REVISION}" \
    org.opencontainers.image.version="${VERSION}"

