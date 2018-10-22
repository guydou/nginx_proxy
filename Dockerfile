FROM        ubuntu:16.04
MAINTAINER  Robert Reiz <reiz@versioneye.com>

WORKDIR /app

ADD sources.list /etc/apt/sources.list

RUN apt-get update; \
    apt-get install -y libfontconfig1; \
    apt-get install -y libpcre3; \ 
    apt-get install -y libpcre3-dev; \
    apt-get install -y git; \
    apt-get install -y dpkg-dev; \
    apt-get install -y libpng-dev; \
    apt-get autoclean && apt-get autoremove;

RUN apt-get install -y wget unzip
RUN cd /app && wget https://codeload.github.com/nginx/nginx/zip/release-1.15.5 -O ngx.zip  && unzip ngx.zip
RUN cd /app/ && git clone https://github.com/chobits/ngx_http_proxy_connect_module;
RUN cd /app/nginx-* && patch -p1 < ../ngx_http_proxy_connect_module/patch/proxy_connect_rewrite_1015.patch;
RUN cd /app/nginx-* && auto/configure --with-http_slice_module --add-module=/app/ngx_http_proxy_connect_module && make && make install;
RUN apt-get install -y gettext

ADD simple_proxy.conf /usr/local/nginx/conf/nginx.conf.template

EXPOSE 8888
ADD run_nginx.sh  run_nginx.sh
RUN chmod +x run_nginx.sh

ENV RESOLVER=8.8.8.8

CMD ./run_nginx.sh
