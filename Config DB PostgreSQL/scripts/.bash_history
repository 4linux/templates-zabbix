psql -U zabbix -h 192.168.100.100 -c "SELECT 1;" zabbixdb -tA
exit
pwd
exit
whoami
exit
psql -U postgres -h 192.168.100.100 -c "SELECT 1;" postgres -tA
psql -U zabbix -h 192.168.100.100 -c "SELECT 1;" postgres -tA
psql -U zabbix -h 192.168.100.100 -c "SELECT 1;" zabbixdb -tA
exit
/etc/zabbix/zabbix_agentd.d/scripts/pgsql_detect_database.sh
