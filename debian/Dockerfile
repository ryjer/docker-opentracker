FROM debian:bookworm-slim

# XDG目录规范
ENV XDG_CONFIG_HOME=/etc/opentracker

# 安装 curl 用于健康检查，并创建配置目录
RUN apt update -y\
    && apt install curl opentracker -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 暴露配置卷
VOLUME ["/etc/opentracker"]

COPY ./opentracker.conf /etc/opentracker/opentracker.conf

EXPOSE 6969/tcp
EXPOSE 6969/udp

CMD ["/bin/opentracker", "-f", "/etc/opentracker/opentracker.conf"]

