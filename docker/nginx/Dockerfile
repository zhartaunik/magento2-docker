FROM nginx:1.21

MAINTAINER Nick Jones <nick@nicksays.co.uk>

ADD etc/vhost.conf /etc/nginx/conf.d/default.conf
ADD etc/nginx.conf /etc/nginx/nginx.conf
COPY etc/certs/ /etc/nginx/ssl/
ADD bin/* /usr/local/bin/

EXPOSE 80
EXPOSE 443

RUN ["chmod", "+x", "/usr/local/bin/docker-environment"]

ENTRYPOINT ["/usr/local/bin/docker-environment"]
CMD ["nginx", "-g", "daemon off;"]

RUN groupadd -g 1000 magento
RUN useradd -d /home/magento -s /bin/bash -u 1000 -g 1000 magento
RUN mkdir /home/magento
RUN chown -R magento:magento /home/magento
#RUN chown -R magento:magento /var/www/magento

RUN touch /var/run/nginx.pid \
 && chown -R magento:magento /var/run/nginx.pid /var/cache/nginx

#USER magento
