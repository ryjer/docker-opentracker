FROM debian:bullseye-slim AS build

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
    && sed -i '/FEATURES+=-DWANT_IP_FROM_QUERY_STRING$/s/^#//' Makefile \
    && sed -i '/^FEATURES+=-DWANT_FULLSCRAPE$/s/^/#/' Makefile
    && make -j4


FROM debian:bullseye-slim

# XDG目录规范
ENV XDG_CONFIG_HOME=/config

COPY --from=build /src/opentracker/opentracker /bin/opentracker

# 安装 curl 用于健康检查，并创建配置目录
RUN apt update -y\
    && apt install curl -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p ${XDG_CONFIG_HOME}

VOLUME ["${XDG_CONFIG_HOME}"]
COPY ./opentracker.conf ${XDG_CONFIG_HOME}/opentracker.conf
COPY ./whitelist	${XDG_CONFIG_HOME}/whitelist
COPY ./blacklist	${XDG_CONFIG_HOME}/blacklist

EXPOSE 6969/tcp 
EXPOSE 6969/udp

CMD ["/bin/opentracker", "-f", "/config/opentracker.conf"]
