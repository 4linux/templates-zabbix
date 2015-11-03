#!/bin/bash

INSTANCENAME=$(cat /etc/zabbix/zabbix_agentd.d/scripts/4linux_parameters.txt | cut -d\; -f2 | tail -1)
ORACLE_HOME=$(cat /etc/zabbix/zabbix_agentd.d/scripts/4linux_parameters.txt  | grep $INSTANCENAME | cut -d\; -f4)
SYS_SENHA=$(cat /etc/zabbix/zabbix_agentd.d/scripts/4linux_parameters.txt  | grep $INSTANCENAME | cut -d\; -f6)

function check { 
export ORACLE_SID=${INSTANCENAME}
export ORACLE_HOME=${ORACLE_HOME}
${ORACLE_HOME}/bin/sqlplus -S /nolog << EOF

connect sys/$SYS_SENHA as sysdba

SELECT TO_CHAR(ROUND(SUM(decode(pool,'shared pool',decode(name,'library cache',0,'dictionary cache',0,'free memory',0,'sql area',0,(bytes)/(1024*1024)),0)),2)) pool_misc FROM V\$SGASTAT;

exit
EOF
}
NUM=$(check)
echo $NUM | awk -F" " '{print $3}'
