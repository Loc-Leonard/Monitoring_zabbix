#!/usr/bin/env bash
set -e

# Устанавливаем hostname (без systemd)
if [ -n "${HOSTNAME_VALUE}" ]; then
  echo "${HOSTNAME_VALUE}" > /etc/hostname
  hostname "${HOSTNAME_VALUE}"
fi

mkdir -p /root/.ssh /var/run/sshd

# Отключаем парольный логин в sshd
sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config

ssh-keygen -A

# Генерим SNMPv3-конфиг
cat >/etc/snmp/snmpd.conf <<SNMPEOF
agentaddress udp:161
rouser ${SNMPV3_USER:-monuser} authPriv
createUser ${SNMPV3_USER:-monuser} SHA ${SNMPV3_AUTH:-AuthPass123!} AES ${SNMPV3_PRIV:-PrivPass123!}
sysLocation DockerLab
sysContact admin@example.local
SNMPEOF

# Настраиваем Zabbix Agent2
sed -i "s/^Hostname=.*/Hostname=${HOSTNAME_VALUE:-host}/" /etc/zabbix/zabbix_agent2.conf
sed -i "s/^Server=.*/Server=${ZBX_SERVER_HOST:-zabbix-server}/" /etc/zabbix/zabbix_agent2.conf
sed -i "s/^ServerActive=.*/ServerActive=${ZBX_SERVER_HOST:-zabbix-server}/" /etc/zabbix/zabbix_agent2.conf

# Правим rsyslog-клиент (центральный сервер логов)
sed -i "s|@@RSYSLOG_SERVER@@|${RSYSLOG_SERVER:-rsyslog-server}|g" /etc/rsyslog.d/60-central.conf

# Запускаем apache без systemd
apachectl -k restart || apachectl -k start || true

# Запускаем все демоны через supervisord
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf