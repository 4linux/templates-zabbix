#!/bin/bash
#================================================================================
#
#  Programa :  find_tablespace.sh
#
#  Objetivo :  Listar as tablespaces existentes no ambiente..
#
#================================================================================

INSTANCENAME=$(cat /etc/zabbix/zabbix_agentd.d/scripts/4linux_parameters.txt | cut -d\; -f2 | tail -1)
ORACLE_HOME=$(cat /etc/zabbix/zabbix_agentd.d/scripts/4linux_parameters.txt  | grep $INSTANCENAME | cut -d\; -f4)
SYS_SENHA=$(cat /etc/zabbix/zabbix_agentd.d/scripts/4linux_parameters.txt  | grep $INSTANCENAME | cut -d\; -f6)

function list_tablespaces  { 
export ORACLE_SID=${ORACLE_SID}
export ORACLE_HOME=${ORACLE_HOME}
${ORACLE_HOME}/bin/sqlplus -S  /nolog << EOF

connect sys/$SYS_SENHA as sysdba

set linesize 1000
set trimspool on  
set heading off
set feedback off
set echo off
set trims on
set flush off

select TABLESPACE_NAME from DBA_TABLESPACES where CONTENTS not in ('TEMPORARY','UNDO');
quit
EOF
} 

for instancename in $INSTANCENAME; do
# Altera variavel para coleta apenas tablespace necessarias
  export ORACLE_SID=$instancename
  export ORACLE_HOME=$(cat /etc/zabbix/zabbix_agentd.d/scripts/4linux_parameters.txt  | grep $instancename | cut -d\; -f4)
  GETTABLESPACES=$(list_tablespaces)

STATUS=$(/etc/zabbix/zabbix_agentd.d/scripts/check_instance_status.sh ${instancename})
if [ ${STATUS} -eq 0 ] ; then
        for tablespacesname in $GETTABLESPACES; do
            tablespace_instances="$tablespace_instances,"'{"{#TABLESPACESNAME}":"'$tablespacesname'","{#INSTANCENAME}":"'$instancename'"}'
        done
fi

done
echo '{"data":['${tablespace_instances#,}' ]}'
