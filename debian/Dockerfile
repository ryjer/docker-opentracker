FROM debian:buster-slim AS build

WORKDIR /src

RUN apt-get update -y\
    && apt-get -y install gcc \
        g++ \
        make \
        git \
        cvs \
        zlib1g-dev

RUN cvs -d :pserver:cvs@cvs.fefe.de:/cvs -z9 co libowfat \
    && cd libowfat \
    && make

RUN git clone git://erdgeist.org/opentracker \
    && cd opentracker \
    && make -j4


FROM debian:buster-slim

# XDG目录规范
ENV XDG_CONFIG_HOME=/config

COPY --from=build /src/opentracker/opentracker /bin/opentracker

RUN apt update -y\
    && apt install curl -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

VOLUME ["${XDG_CONFIG_HOME}"]
COPY ./opentracker.conf ${XDG_CONFIG_HOME}/opentracker.conf
COPY ./whitelist	${XDG_CONFIG_HOME}/whitelist
COPY ./blacklist	${XDG_CONFIG_HOME}/blacklist

EXPOSE 6969/tcp 
EXPOSE 6969/udp

HEALTHCHECK --interval=3m --timeout=4s --retries=3 --start-period=3s \
    CMD curl -fs http://localhost:6969/stats || exit 1

CMD ["/bin/opentracker", "-f", "${XDG_CONFIG_HOME}/opentracker.conf"]
