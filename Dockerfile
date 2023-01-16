FROM nginx:latest
MAINTAINER ifeng <https://t.me/HiaiFeng>
EXPOSE 443
USER root

RUN apt-get update && apt-get install -y supervisor wget unzip

# 定义 UUID 及 伪装路径,请自行修改.(注意:伪装路径以 / 符号开始,为避免不必要的麻烦,请不要使用特殊符号.)
ENV UUID de04add9-5c68-8bab-950c-08cd5320df18
ENV VMESS_WSPATH /vmess
ENV VLESS_WSPATH /vless

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY nginx.conf /etc/nginx/nginx.conf

RUN mkdir /etc/xray /usr/local/xray
COPY config.json /etc/xray/
COPY entrypoint.sh /usr/local/xray/

# 感谢 fscarmen 大佬提供 Dockerfile 层优化方案
RUN wget -q -O /tmp/Xray-linux-64.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip && \
    unzip -d /usr/local/xray /tmp/Xray-linux-64.zip && \
    chmod a+x /usr/local/xray/entrypoint.sh

ENTRYPOINT [ "/usr/local/xray/entrypoint.sh" ]
CMD ["/usr/bin/supervisord"]
