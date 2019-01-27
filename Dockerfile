FROM alpine:edge

MAINTAINER Ma Feng<mengjue@outlook.com>

WORKDIR /root

ENV RPC_SECRET=Hello
ENV ENABLE_AUTH=false
ENV DOMAIN=0.0.0.0:80
ENV ARIA2_USER=user
ENV ARIA2_PWD=password

RUN apk update && apk add wget bash curl openrc gnupg screen aria2 tar --no-cache

RUN apk add caddy
#RUN curl --fail https://getcaddy.com | bash -s personal http.filemanager

ADD conf /root/conf

COPY Caddyfile /usr/local/caddy/Caddyfile
COPY SecureCaddyfile /usr/local/caddy/SecureCaddyfile

RUN mkdir -p /usr/local/www && mkdir -p /usr/local/www/aria2

#AriaNg
RUN mkdir /usr/local/www/aria2/Download && cd /usr/local/www/aria2 \
 && chmod +rw /root/conf/aria2.session \
 && wget -N --no-check-certificate https://github.com/mayswind/AriaNg/releases/download/1.0.0/AriaNg-1.0.0-AllInOne.zip && unzip AriaNg-1.0.0-AllInOne.zip && rm -rf AriaNg-1.0.0-AllInOne.zip \
 && chmod -R 755 /usr/local/www/aria2 \
 && chmod +x /root/conf/aria2c.sh \
 && chmod +x /root/conf/get-bt-list \
 && ln -s /root/conf/get-bt-list /etc/periodic/weekly/

#The folder to store ssl keys
VOLUME /root/conf

# For user downloaded files
VOLUME /data

EXPOSE 6800 80 443

ENTRYPOINT ["/bin/sh", "/root/conf/aria2c.sh"]
