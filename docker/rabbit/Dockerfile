FROM rabbitmq:3.9-management

# Define environment variables.
ENV RABBITMQ_USER ${RABBITMQ_USER}
ENV RABBITMQ_PASSWORD ${RABBITMQ_PASSWORD}
ENV RABBITMQ_PID_FILE /var/lib/rabbitmq/mnesia/rabbitmq

ADD docker-entrypoint.sh /docker-entrypoint.sh

RUN ["chmod", "+x", "/docker-entrypoint.sh"]

ENTRYPOINT ["/docker-entrypoint.sh"]
