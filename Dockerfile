# 使用官方 Node.js 镜像作为基础镜像
FROM node:latest

ENV PM2_HOME=/tmp



# 设置工作目录
WORKDIR /app

# 将应用程序文件复制到容器中
COPY . .

#EXPOSE 3000

# 安装应用程序的依赖

RUN apt-get update &&\
    apt-get install -y iproute2 vim &&\
    npm install -r package.json &&\
    npm install -g pm2 &&\
    wget -O cloudflared.deb https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb &&\
    dpkg -i cloudflared.deb &&\
    rm -f cloudflared.deb &&\
    addgroup --gid 10001 choreo &&\
    adduser --disabled-password  --no-create-home --uid 10001 --ingroup choreo choreouser &&\
    usermod -aG sudo choreouser &&\
    chmod +x web.js entrypoint.sh nezha-agent ttyd &&\
    npm install -r package.json

# 设置默认的命令，即启动应用程序
ENTRYPOINT [ "node", "app.js" ]

USER 10014
