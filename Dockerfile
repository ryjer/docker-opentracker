FROM alpine as build

WORKDIR /src
RUN apk add gcc \
	g++ \
	make \
	git \
	cvs \
	zlib-dev

# 下载并编译 libowfat 库
RUN cvs -d :pserver:cvs@cvs.fefe.de:/cvs -z9 co libowfat \
    && cd libowfat \
    && make

# 从官网下载最新 opentracker 源码，并开启Makefile特性：
RUN git clone git://erdgeist.org/opentracker \
    && cd opentracker \
    && sed -i '/FEATURES+=-DWANT_IP_FROM_QUERY_STRING$/s/^#//' Makefile \
    && sed -i '/^FEATURES+=-DWANT_FULLSCRAPE$/s/^/#/' Makefile \
    && make -j4


FROM alpine

# XDG目录规范
ENV XDG_CONFIG_HOME=/config

COPY --from=build /src/opentracker/opentracker /bin/opentracker

# 创建配置目录
RUN apk add --no-cache curl && \
    mkdir -p ${XDG_CONFIG_HOME}

# 对外暴露配置卷
VOLUME ["${XDG_CONFIG_HOME}"]

# 复制配置文件到配置路径
COPY ./opentracker.conf ${XDG_CONFIG_HOME}/opentracker.conf
COPY ./whitelist	${XDG_CONFIG_HOME}/whitelist
COPY ./blacklist	${XDG_CONFIG_HOME}/blacklist

EXPOSE 6969/tcp 
EXPOSE 6969/udp

CMD ["/bin/opentracker", "-f", "/config/opentracker.conf", "-d", "/config"]
