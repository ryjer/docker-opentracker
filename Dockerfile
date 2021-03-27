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
    && make -j2

FROM alpine

COPY --from=build /src/opentracker/opentracker /bin/opentracker

RUN apk add --no-cache curl

VOLUME ["/conf"]

COPY ./opentracker.conf /conf/opentracker.conf
COPY ./whitelist	/conf/whitelist
COPY ./blacklist	/conf/blacklist

EXPOSE 6969/tcp 
EXPOSE 6969/udp

HEALTHCHECK --interval=3m --timeout=4s --retries=3 --start-period=3s \
    CMD curl -fs http://localhost:6969/stats || exit 1

CMD ["/bin/opentracker", "-f", "/conf/opentracker.conf", "-p", "6969", "-P", "6969"]
