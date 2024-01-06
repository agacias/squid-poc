FROM ubuntu/squid:latest
RUN apt update && \
    apt -y install curl rsyslog && \
    sed -i '/imklog/s/^/#/' /etc/rsyslog.conf

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh
