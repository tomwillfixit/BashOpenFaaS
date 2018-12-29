FROM alpine:3.8

RUN apk add --no-cache bash

RUN mkdir -p /home/app

RUN apk --no-cache add curl \
    && echo "Pulling watchdog binary from Github." \
    && curl -sSL https://github.com/openfaas/faas/releases/download/0.9.6/fwatchdog > /usr/bin/fwatchdog \
    && chmod +x /usr/bin/fwatchdog \
    && cp /usr/bin/fwatchdog /home/app \
    && apk del curl --no-cache
   
RUN apk add --no-cache whois iputils 

# Add non root user
RUN addgroup -S app && adduser app -S -G app

RUN chown app /home/app

WORKDIR /home/app

USER app

ADD test.sh /tmp/test.sh

# Populate example here - i.e. "cat", "sha512sum" or "node index.js"
ENV fprocess="xargs bash /tmp/test.sh"
# Set to true to see request in function logs
ENV write_debug="true"

EXPOSE 8080

ENV PWD /home/app
ENV HOME /home/app

RUN env
RUN ls /home/app

HEALTHCHECK --interval=3s CMD [ -e /tmp/.lock ] || exit 1
CMD [ "fwatchdog" ]
