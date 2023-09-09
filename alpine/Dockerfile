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
    && make \
    && cd .. \
    && git clone git://erdgeist.org/opentracker \
    && cd opentracker \
    && make

FROM alpine

# XDG目录规范
ENV XDG_CONFIG_HOME=/config

COPY --from=build /src/opentracker/opentracker /bin/opentracker

RUN apk add --no-cache curl && \
    mkdir -p ${XDG_CONFIG_HOME}

VOLUME ["${XDG_CONFIG_HOME}"]

COPY ./opentracker.conf ${XDG_CONFIG_HOME}/opentracker.conf
COPY ./whitelist	${XDG_CONFIG_HOME}/whitelist
COPY ./blacklist	${XDG_CONFIG_HOME}/blacklist

EXPOSE 6969/tcp 
EXPOSE 6969/udp

HEALTHCHECK --interval=3m --timeout=4s --retries=3 --start-period=3s \
    CMD curl -fs http://localhost:6969/stats || exit 1

CMD ["/bin/opentracker", "-f", "${XDG_CONFIG_HOME}/opentracker.conf", "-d", "${XDG_CONFIG_HOME}", "-p", "6969", "-P", "6969"]
