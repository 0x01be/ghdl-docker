FROM alpine as build

RUN apk add --no-cache --virtual ghdl-build-dependencies \
    git \
    build-base \
    gcc-gnat \
    libexecinfo-dev \
    zlib-dev

ENV GHDL_REVISION v0.37.0
RUN git clone --depth 1 --branch ${GHDL_REVISION} https://github.com/ghdl/ghdl /ghdl

WORKDIR /ghdl

RUN ./configure --prefix=/opt/ghdl

# No backtrace support on alpine
RUN sed -i.bak 's/#include <sys\/ucontext.h>//g' /ghdl/src/grt/config/jumps.c
RUN sed -i.bak 's/#define HAVE_BACKTRACE 1//g' /ghdl/src/grt/config/jumps.c
RUN make
RUN make install

#FROM alpine

#COPY --from=builder /opt/ghdl/ /opt/ghdl/

#ENV PATH $PATH:/opt/ghdl/bin/

