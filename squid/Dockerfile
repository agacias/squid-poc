FROM ubuntu/squid:latest
RUN apt update && \
    apt -y --no-install-recommends install curl && \
    apt-get remove --purge --auto-remove -y && \
	rm -rf /var/lib/apt/lists/*