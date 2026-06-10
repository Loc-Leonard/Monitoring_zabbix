FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y rsyslog ca-certificates && \
    mkdir -p /var/log/remote && \
    rm -rf /var/lib/apt/lists/*

COPY rsyslog.conf /etc/rsyslog.conf

CMD ["rsyslogd", "-n", "-f", "/etc/rsyslog.conf"]