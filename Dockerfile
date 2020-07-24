ARG VERSION v0.37.0

FROM alpine:3.12.0 as builder

RUN apk add --no-cache --virtual build-dependencies \
    git \
    build-base \
    gcc-gnat
RUN apk add libexecinfo-dev
RUN apk add zlib-dev

RUN git clone --depth 1 --branch $VERSION https://github.com/ghdl/ghdl /ghdl

WORKDIR /ghdl

RUN ./configure --prefix=/opt/ghdl
RUN make
RUN make install

FROM alpine:3.12.0

COPY --from=builder /opt/ghdl/ /opt/ghdl/

