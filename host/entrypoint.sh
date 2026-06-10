#!/usr/bin/env bash
set -e

hostnamectl set-hostname "${HOSTNAME_VALUE:-host}"
mkdir -p /root/.ssh /var/run/sshd

sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config

ssh-keygen -A

cat >/etc/snmp/snmpd.conf <<SNMPEOF
agentaddress udp:161
rouser ${SNMPV3_USER:-monuser} authPriv
createUser ${SNMPV3_USER:-monuser} SHA ${SNMPV3_AUTH:-AuthPass123!} AES ${SNMPV3_PRIV:-PrivPass123!}
sysLocation DockerLab
sysContact admin@example.local
SNMPEOF

sed -i "s/^Hostname=.*/Hostname=${HOSTNAME_VALUE:-host}/" /etc/zabbix/zabbix_agent2.conf
sed -i "s/^Server=.*/Server=${ZBX_SERVER_HOST:-zabbix-server}/" /etc/zabbix/zabbix_agent2.conf
sed -i "s/^ServerActive=.*/ServerActive=${ZBX_SERVER_HOST:-zabbix-server}/" /etc/zabbix/zabbix_agent2.conf
sed -i "s|@@RSYSLOG_SERVER@@|${RSYSLOG_SERVER:-rsyslog-server}|g" /etc/rsyslog.d/60-central.conf

service apache2 restart || true

exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf