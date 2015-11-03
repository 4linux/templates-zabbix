#!/bin/bash

INSTANCENAME=$(cat /etc/zabbix/zabbix_agentd.d/scripts/4linux_parameters.txt | cut -d\; -f2 | tail -1)
ORACLE_HOME=$(cat /etc/zabbix/zabbix_agentd.d/scripts/4linux_parameters.txt  | grep $INSTANCENAME | cut -d\; -f4)
SYS_SENHA=$(cat /etc/zabbix/zabbix_agentd.d/scripts/4linux_parameters.txt  | grep $INSTANCENAME | cut -d\; -f6)

function check { 
export ORACLE_SID=${INSTANCENAME}
export ORACLE_HOME=${ORACLE_HOME}
${ORACLE_HOME}/bin/sqlplus -S /nolog << EOF

connect sys/$SYS_SENHA as sysdba

SELECT to_char(sum(decode(event,'control file sequential read',0,'control file single write',0,'control file parallel write',0,'db file sequential read',0,'db file scattered read',0,'direct path read',0,'file identify',0,'file open',0,'SQL*Net message to client',0,'SQL*Net message to dblink',0, 'SQL*Net more data to client',0,'SQL*Net more data to dblink',0, 'SQL*Net break/reset to client',0,'SQL*Net break/reset to dblink',0, 'log file single write',0,'log file parallel write',0,total_waits))) Other FROM V\$system_event WHERE 1=1 AND event not in (  'SQL*Net message from client', 'SQL*Net more data from client', 'pmon timer', 'rdbms ipc message',  'rdbms ipc reply', 'smon timer');

exit
EOF
}
NUM=$(check)
echo $NUM | awk -F" " '{print $3}'
