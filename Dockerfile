FROM alpine as build

WORKDIR /src
RUN apk add gcc \
	g++ \
	make \
	git \
	cvs \
	zlib-dev

RUN cvs -d :pserver:cvs@cvs.fefe.de:/cvs -z9 co libowfat \
    && cd libowfat \
    && make

RUN git clone git://erdgeist.org/opentracker \
    && cd opentracker \
    && make -j4


FROM alpine

# XDG目录规范
ENV XDG_CONFIG_HOME=/config

COPY --from=build /src/opentracker/opentracker /bin/opentracker

RUN mkdir -p ${XDG_CONFIG_HOME}

# 对外暴露配置卷
VOLUME ["${XDG_CONFIG_HOME}"]

COPY ./opentracker.conf ${XDG_CONFIG_HOME}/opentracker.conf
COPY ./whitelist	${XDG_CONFIG_HOME}/whitelist
COPY ./blacklist	${XDG_CONFIG_HOME}/blacklist

EXPOSE 6969/tcp 
EXPOSE 6969/udp

CMD ["/bin/opentracker", "-f", "/config/opentracker.conf"]
