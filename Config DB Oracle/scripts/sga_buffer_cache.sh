#!/bin/bash

INSTANCENAME=$(cat /etc/zabbix/zabbix_agentd.d/scripts/4linux_parameters.txt | cut -d\; -f2 | tail -1)
ORACLE_HOME=$(cat /etc/zabbix/zabbix_agentd.d/scripts/4linux_parameters.txt  | grep $INSTANCENAME | cut -d\; -f4)
SYS_SENHA=$(cat /etc/zabbix/zabbix_agentd.d/scripts/4linux_parameters.txt  | grep $INSTANCENAME | cut -d\; -f6)

function check { 
export ORACLE_SID=${INSTANCENAME}
export ORACLE_HOME=${ORACLE_HOME}
${ORACLE_HOME}/bin/sqlplus -S /nolog << EOF

connect sys/$SYS_SENHA as sysdba

SELECT to_char(ROUND(SUM(decode(pool,NULL,decode(name,'db_block_buffers',(bytes)/(1024*1024),'buffer_cache',(bytes)/(1024*1024),0),0)),2)) sga_bufcache FROM V\$SGASTAT;

exit
EOF
}
NUM=$(check)
echo $NUM | awk -F" " '{print $3}'
