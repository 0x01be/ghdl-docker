FROM alpine:3.12.0 as builder
ENV VERSION v0.37.0

RUN apk add --no-cache --virtual build-dependencies \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
    git \
    build-base \
    gcc-gnat \
    libexecinfo-dev \
    zlib-dev

RUN git clone --depth 1 --branch $VERSION https://github.com/ghdl/ghdl /ghdl

WORKDIR /ghdl

RUN ./configure --prefix=/opt/ghdl
RUN make
RUN make install

FROM alpine:3.12.0

COPY --from=builder /opt/ghdl/ /opt/ghdl/

ENV PATH $PATH:/opt/ghdl/bin/

