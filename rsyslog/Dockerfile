FROM alpine:3.19

RUN apk add --no-cache rsyslog

WORKDIR /var/log

EXPOSE 514/tcp \
       514/udp

ENTRYPOINT ["rsyslogd", "-n"]