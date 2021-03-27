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
# tt

FROM debian:buster-slim

COPY --from=build /src/opentracker/opentracker /bin/opentracker

RUN apt update -y\
    && apt install curl -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

VOLUME ["/conf"]
COPY ./opentracker.conf /conf/opentracker.conf
COPY ./whitelist	/conf/whitelist
COPY ./blacklist	/conf/blacklist

EXPOSE 6969/tcp 
EXPOSE 6969/udp

HEALTHCHECK --interval=3m --timeout=4s --retries=3 --start-period=3s \
    CMD curl -fs http://localhost:6969/stats || exit 1

CMD ["/bin/opentracker", "-f", "/conf/opentracker.conf"]
