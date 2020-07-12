ARG SOURCE
ARG REVISION
ARG CREATED
ARG VERSION
ARG GIT_REF="${VERSION}"

FROM alpine:edge as builder

ARG GIT_REF

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
    && git clone --branch "${GIT_REF}" --depth 1 "https://github.com/ledger/ledger" \
    && cd ledger \
    && ln -s /usr/bin/python3 /usr/bin/python

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
ARG SOURCE
ARG REVISION
ARG CREATED

COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /lib/ld-musl-x86_64.so.1 /lib/
COPY --from=builder /usr/local/bin/ledger /usr/local/bin/ledger

USER ledger

WORKDIR /home/ledger/data

ENTRYPOINT ["ledger"]

LABEL org.opencontainers.image.title="ledger" \
    org.opencontainers.image.description="ledger in Docker" \
    org.opencontainers.image.source="${SOURCE}" \
    org.opencontainers.image.revision="${REVISION}" \
    org.opencontainers.image.created="${CREATED}" \
    org.opencontainers.image.version="${VERSION}"

