FROM nginx:1.9

MAINTAINER Nick Jones <nick@nicksays.co.uk>

ADD etc/vhost.conf /etc/nginx/conf.d/default.conf
COPY etc/certs/ /etc/nginx/ssl/
ADD bin/* /usr/local/bin/

EXPOSE 443

RUN ["chmod", "+x", "/usr/local/bin/docker-environment"]

ENTRYPOINT ["/usr/local/bin/docker-environment"]
CMD ["nginx", "-g", "daemon off;"]
