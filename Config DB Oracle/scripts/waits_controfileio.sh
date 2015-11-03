#!/bin/bash

INSTANCENAME=$(cat /etc/zabbix/zabbix_agentd.d/scripts/4linux_parameters.txt | cut -d\; -f2 | tail -1)
ORACLE_HOME=$(cat /etc/zabbix/zabbix_agentd.d/scripts/4linux_parameters.txt  | grep $INSTANCENAME | cut -d\; -f4)
SYS_SENHA=$(cat /etc/zabbix/zabbix_agentd.d/scripts/4linux_parameters.txt  | grep $INSTANCENAME | cut -d\; -f6)

function check { 
export ORACLE_SID=${INSTANCENAME}
export ORACLE_HOME=${ORACLE_HOME}
${ORACLE_HOME}/bin/sqlplus -S /nolog << EOF

connect sys/$SYS_SENHA as sysdba

SELECT to_char(sum(decode(event,'control file sequential read', total_waits, 'control file single write', total_waits, 'control file parallel write',total_waits,0))) ControlFileIO FROM V\$system_event WHERE 1=1 AND event not in ( 'SQL*Net message from client', 'SQL*Net more data from client','pmon timer', 'rdbms ipc message', 'rdbms ipc reply', 'smon timer');

exit
EOF
}
NUM=$(check)
echo $NUM | awk -F" " '{print $3}'
