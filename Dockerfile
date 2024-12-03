ARG AZCOPY_VERSION
ARG GO_VERSION=1.23
ARG ALPINE_VERSION=3.19

FROM golang:$GO_VERSION-alpine$ALPINE_VERSION as build
ENV GOOS=linux
WORKDIR /azcopy
ARG AZCOPY_VERSION
RUN apk add --no-cache build-base
RUN wget "https://github.com/Azure/azure-storage-azcopy/archive/v$AZCOPY_VERSION.tar.gz" -O src.tgz || wget "https://github.com/Azure/azure-storage-azcopy/archive/$AZCOPY_VERSION.tar.gz" -O src.tgz
RUN tar xf src.tgz --strip 1 \
 && go build -o azcopy \
 && ./azcopy --version

FROM alpine:$ALPINE_VERSION AS release
ARG AZCOPY_VERSION
LABEL name="docker-azcopy"
LABEL version="$AZCOPY_VERSION"
LABEL maintainer="Peter Dave Hello <hsu@peterdavehello.org>"
COPY --from=build /azcopy/azcopy /usr/local/bin
WORKDIR /WORKDIR
CMD [ "azcopy" ]
