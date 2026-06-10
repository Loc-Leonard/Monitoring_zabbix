FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    openssh-server rsyslog snmpd snmp net-tools iputils-ping curl wget \
    apache2 stress-ng python3 python3-pip supervisor gnupg ca-certificates \
    && mkdir -p /run/sshd /var/log/supervisor /etc/zabbix/zabbix_agentd.d

RUN wget -q https://repo.zabbix.com/zabbix/7.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest_7.0+ubuntu24.04_all.deb \
    && dpkg -i zabbix-release_latest_7.0+ubuntu24.04_all.deb \
    && apt-get update && apt-get install -y zabbix-agent2 \
    && rm -f zabbix-release_latest_7.0+ubuntu24.04_all.deb

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY entrypoint.sh /entrypoint.sh
COPY zabbix_agent2.conf /etc/zabbix/zabbix_agent2.conf
COPY rsyslog-client.conf /etc/rsyslog.d/60-central.conf
COPY snmpd.conf.template /etc/snmp/snmpd.conf.template
COPY apache_status.conf /etc/apache2/conf-available/zabbix-status.conf

RUN a2enconf zabbix-status && a2enmod status && chmod +x /entrypoint.sh

EXPOSE 22 80 10050 161/udp

ENTRYPOINT ["/entrypoint.sh"]