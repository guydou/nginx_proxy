#!/usr/bin/env bash
envsubst '$RESOLVER' < /usr/local/nginx/conf/nginx.conf.template > /usr/local/nginx/conf/nginx.conf
/usr/local/nginx/sbin/nginx
