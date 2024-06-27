FROM node:16

WORKDIR /app

# add `/app/node_modules/.bin` to $PATH
ENV PATH /app/node_modules/.bin:$PATH

# Install necessary packages
RUN apt-get update && apt-get install -y sudo openssl && apt-get clean

# Create a custom user and group
RUN groupadd -g 1001 customuser
RUN useradd --no-log-init -d /home/customuser -s /bin/bash -u 1001 -g customuser customuser
RUN echo "customuser:customuser" | chpasswd && adduser customuser sudo

RUN mkdir -p /home/customuser
RUN chown -R customuser:customuser /home/customuser
RUN chown -R customuser:customuser /app
#RUN chown customuser:customuser /usr/local/share/ca-certificates/devcert.crt

ENV NODE_TLS_REJECT_UNAUTHORIZED=0

# Copy the application code
COPY . /app
RUN chown -R customuser:customuser /app

USER customuser

# Install dependencies
RUN npm install

# Start the container in a sleep state to keep it running
CMD ["npm", "start"]
