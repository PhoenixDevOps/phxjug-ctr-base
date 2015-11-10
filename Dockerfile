FROM gliderlabs/alpine:3.2

# Install bash
RUN apk-install bash

# Download and install glibc so we can run Java 8 (among other things)
# WARNING: This means we'll have two C runtime libraries -- glibc and musl -- running simultaneously.  There's a small chance this may cause issues.  See https://github.com/gliderlabs/docker-alpine/issues/11#issuecomment-91337556.
# Steps taken from https://github.com/gliderlabs/docker-alpine/issues/11#issuecomment-91329401 and https://registry.hub.docker.com/u/frolvlad/alpine-oraclejdk8/dockerfile/
RUN apk add --update curl &&\
    apk add --update openssl &&\
    curl -o glibc-2.21-r2.apk "https://s3-us-west-2.amazonaws.com/farm-artifacts/glibc-2.21-r2.apk" && \
    apk add --allow-untrusted glibc-2.21-r2.apk && \
    curl -o glibc-bin-2.21-r2.apk "https://s3-us-west-2.amazonaws.com/farm-artifacts/glibc-bin-2.21-r2.apk" && \
    apk add --allow-untrusted glibc-bin-2.21-r2.apk && \
    /usr/glibc/usr/bin/ldconfig /lib /usr/glibc/usr/lib && \
    apk del curl &&\
    rm -rf /var/cache/apk/*

ENTRYPOINT ["/bin/bash"]
