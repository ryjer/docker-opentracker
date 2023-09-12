FROM alpine as build

WORKDIR /src

RUN apk add gcc \
	g++ \
	make \
	git \
	cvs \
	zlib-dev

# 下载依赖库 libowfat 和 opentracker，设置opentracker特性：支持ipv6、黑名单、允许通告ip、不公开详情、关闭fullscrape
RUN cvs -d :pserver:cvs@cvs.fefe.de:/cvs -z9 co libowfat \
    && cd libowfat \
    && make -j4 \
    && cd .. \
    && git clone git://erdgeist.org/opentracker \
    && cd opentracker \
    && sed -i '/^#FEATURES+=-DWANT_V6$/s/^#//' Makefile \
    && sed -i '/^#FEATURES+=-DWANT_ACCESSLIST_BLACK$/s/^#//' Makefile \
    && sed -i '/^#FEATURES+=-DWANT_IP_FROM_QUERY_STRING$/s/^#//' Makefile \
    && sed -i '/^#FEATURES+=-DWANT_RESTRICT_STATS$/s/^#//' Makefile \
    && sed -i '/^FEATURES+=-DWANT_FULLSCRAPE$/s/^/#/' Makefile
    && make -j4

FROM alpine

# XDG目录规范
ENV XDG_CONFIG_HOME=/config

COPY --from=build /src/opentracker/opentracker /bin/opentracker

# 安装 curl 用于健康检查使用，创建配置目录
RUN apk add --no-cache curl \
    && mkdir -p ${XDG_CONFIG_HOME}

# 暴露配置卷路径
VOLUME ["${XDG_CONFIG_HOME}"]

COPY ./opentracker.conf ${XDG_CONFIG_HOME}/opentracker.conf
COPY ./whitelist	${XDG_CONFIG_HOME}/whitelist
COPY ./blacklist	${XDG_CONFIG_HOME}/blacklist

EXPOSE 6969/tcp 
EXPOSE 6969/udp

# CMD ["/bin/opentracker", "-f", "${XDG_CONFIG_HOME}/opentracker.conf"]
CMD ["/bin/opentracker"]
