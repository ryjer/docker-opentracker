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
    && make -j4 \

RUN git clone git://erdgeist.org/opentracker \
    && cd opentracker \
    && make clean && make -j4


FROM alpine

# XDG目录规范
ENV XDG_CONFIG_HOME=/config

COPY --from=build /src/opentracker/opentracker /bin/opentracker

# 创建配置目录，安装 curl 健康检查使用
RUN apk add --no-cache curl \
    && mkdir -p /config

# 对外暴露配置卷路径
VOLUME ["/config"]

# 复制配置文件到配置路径
COPY ./opentracker.conf /config/opentracker.conf
COPY ./whitelist	/config/whitelist
COPY ./blacklist	/config/blacklist

EXPOSE 6969/tcp 
EXPOSE 6969/udp

CMD ["/bin/opentracker", "-f", "/config/opentracker.conf"]
