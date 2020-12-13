FROM 0x01be/base as build

WORKDIR /ghdl

ENV REVISION=master
RUN apk add --no-cache --virtual ghdl-build-dependencies \
    git \
    build-base \
    gcc-gnat \
    libexecinfo-dev \
    zlib-dev &&\
    git clone --depth 1 --branch ${REVISION} https://github.com/ghdl/ghdl /ghdl &&\
    ./configure --prefix=/opt/ghdl &&\
    sed -i.bak 's/#include <sys\/ucontext.h>//g' /ghdl/src/grt/config/jumps.c &&\
    sed -i.bak 's/#define HAVE_BACKTRACE 1//g' /ghdl/src/grt/config/jumps.c &&\
    make
RUN make install

FROM 0x01be/base

COPY --from=build /opt/ghdl/ /opt/ghdl/

WORKDIR /workspace

RUN apk add --no-cache --virtual ghdl-runtime-dependencies \
    libstdc++ \
    libgnat &&\
    adduser -D -u 1000 ghdl &&\
    chown ghdl:ghdl /workspace

USER ghdl
ENV PATH=${PATH}:/opt/ghdl/bin/

