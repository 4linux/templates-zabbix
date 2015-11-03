#!/bin/bash
#================================================================================
#
#  Programa :  check_jobs.sh
#
#  Objetivo :  Checar se existem job's com falha na execução.
#
#================================================================================

INSTANCENAME=$(cat /etc/zabbix/zabbix_agentd.d/scripts/4linux_parameters.txt | cut -d\; -f2 | tail -1)
ORACLE_HOME=$(cat /etc/zabbix/zabbix_agentd.d/scripts/4linux_parameters.txt  | grep $INSTANCENAME | cut -d\; -f4)
SYS_SENHA=$(cat /etc/zabbix/zabbix_agentd.d/scripts/4linux_parameters.txt  | grep $INSTANCENAME | cut -d\; -f6)

function check { 
export ORACLE_SID=${INSTANCENAME}
export ORACLE_HOME=${ORACLE_HOME}
${ORACLE_HOME}/bin/sqlplus -S /nolog << EOF

connect sys/$SYS_SENHA as sysdba

set echo off;
set feedback off; 
set linesize 1000 ; 
set trimspool on ; 
set heading off;
set feedback off;
set echo off;
set trimspool on;
set flush off;

-- Jobs   > 0 problema
select count(*) retorno from dba_jobs where broken = 'N' and failures > 0 ;

EOF
}
check | grep "0" >> /dev/null
if [ "$?" = "0" ] ; then 
	echo 0 
else 
	echo 1 
fi 
