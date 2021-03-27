# docker-opentracker

![buildx](https://github.com/ryjer/docker-alpine/workflows/buildx-latest/badge.svg)
![buildx](https://github.com/ryjer/docker-alpine/workflows/buildx-debian/badge.svg)
[![Docker Pulls](https://img.shields.io/docker/pulls/ryjer/opentracker.svg)](https://hub.docker.com/r/ryjer/opentracker/)

opentracker is a open and free bittorrent tracker project. It aims for minimal resource usage and is intended to run at your wlan router. 
## Usage
If you want to run a open tracker, just pull the docker image and start up a container:
```bash
docker run -d --name opentracker \
  --restart=always \
  -p 6969:6969/udp \
  -p 6969:6969/tcp \
  ryjer/opentracker
```
Then，open firewall 6969 TCP port and 6969 UDP port.

Stats information：
http://domain:6969/stats or http://IP:6666/stats

Detail stats information:
http://domain:6969/stats?mode=everything or http://IP:6666/stats?mode=everything
## 简介
Opentracker 是一个用C语言实现的高性能 Bt tracker 服务器。其对硬件配置要求较低，甚至可以在低配置的路由器运行。

你可以在制作Bt种子文件的时候将服务器的地址添加到服务器列表中以使用本服务器。

本仓库将 opentracker 服务器封装为一个 docker 容器，并使用 Alpine 作为基础镜像，将镜像总体积控制在 8MB 以内。
## 用法
如果你想运行一个公共的tracker服务器，可以运行以下命令开启一个容器：
```bash
docker run -d --name opentracker \
  --restart=always \
  -p 6969:6969/udp \
  -p 6969:6969/tcp \
  ryjer/opentracker
```
注意：需要同时打开防火墙的 6969 TCP端口 和 6969 UDP端口，请注意检查操作系统的防火墙设置。如果你可以访问下面的**统计信息**网址，说明防火墙 tcp 端口已打开
有的云服务商还会在外层再加一层防火墙，这种情况下你需要将两层防火墙的 6969端口 全部打开。

**统计信息**
注：以下 domain 表示你的 **域名**，IP表示运行 opentracker 容器主机的对外公网IP地址

简略统计信息网址 http://domain:6969/stats 或 http://服务器IP地址:6666/stats

详细统计信息 http://domain:6969/stats?mode=everything 或 http://服务器IP地址:6666/stats?mode=everything
## 高级用法
如果你想自定义一些配置，请将容器的 /conf/opentracker.conf 文件映射到你指定的一个配置文件夹。
然后编辑映射目录中的 opentracker.conf 配置文件（提示：因为没有编译，白名单和黑名单不可用）
```bash
docker run -d --name opentracker \
  --restart=always \
  -v /etc/opentracker/opentracker.conf:/conf/opentracker.conf \
  -p 6969:6969/udp \
  -p 6969:6969/tcp \
  ryjer/opentracker
```
### 制作种子说明
制作种子添加Tracker服务器时，对应服务器地址后需要添加 /announce 路径，示例如下：
```bash
# 如果你有域名（例如 tracker.abc.com），这么写
http://tracker.abc.com:6969/announce
# 如果只有IP，这么写
http://服务器IP地址:6969/announce
```
opentracker 同时也支持 udp 协议，所以也可以添加 udp 地址。
```bash
# 如果你有域名（例如 tracker.abc.com），这么写
udp://tracker.abc.com:6969/announce
# 如果只有IP，这么写
udp://服务器IP地址:6969/announce
```
**如果希望长期使用的话，建议使用域名而非IP**
