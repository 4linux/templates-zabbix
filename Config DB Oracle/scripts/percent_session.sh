#!/bin/bash
#================================================================================
#
#  Programa :  percent_session.sh
#
#  Objetivo :  Informa se a quantidade de sessoes está perto do limite configurado.
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

set feedback off; 
set linesize 1000 ; 
set trimspool on ; 
set heading off;
set echo off;
set trimspool on;
set flush off;

select round((count(p.sid)/x.value)*100,0) from v\$session p, v\$parameter x where x.name='sessions' group by x.value;

EOF
}
NUM=$(check)
echo $NUM
