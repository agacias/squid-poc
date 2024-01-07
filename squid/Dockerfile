FROM ubuntu/squid:latest
RUN apt update && \
    apt -y --no-install-recommends install curl dnsutils && \
    apt-get remove --purge --auto-remove -y && \
	rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh