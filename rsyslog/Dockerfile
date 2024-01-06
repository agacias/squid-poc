FROM alpine:3.19

RUN apk add --no-cache rsyslog && \
    sed -i '/imklog/s/^/#/' /etc/rsyslog.conf

WORKDIR /var/log

EXPOSE 514/tcp \
       514/udp

ENTRYPOINT ["rsyslogd", "-n"]