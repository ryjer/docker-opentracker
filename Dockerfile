FROM alpine

# 创建配置目录，安装 curl 健康检查使用
RUN apk add --no-cache opentracker curl

# 对外暴露配置卷路径
VOLUME ["/etc/opentracker"]

# 复制配置文件到配置路径，alpine默认opentracker配置文件为空
COPY ./opentracker.conf /etc/opentracker/opentracker.conf

EXPOSE 6969/tcp 
EXPOSE 6969/udp

CMD ["/usr/bin/opentracker", "-f", "/etc/opentracker/opentracker.conf"]

