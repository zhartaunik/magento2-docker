FROM varnish:7.0

RUN apt update && apt install -y procps

COPY etc/varnish.vcl /etc/varnish/
COPY bin/docker-entrypoint.sh /docker-entrypoint.sh

RUN chmod +x /docker-entrypoint.sh

ENV VARNISH_CONFIG  /etc/varnish/varnish.vcl
ENV VARNISH_STORAGE malloc,2048m
ENV VARNISH_LISTEN  :6081
ENV VARNISH_MANAGEMENT_LISTEN 127.0.0.1:6082
EXPOSE 6081
EXPOSE 6082

ENTRYPOINT ["/bin/bash", "/docker-entrypoint.sh"]