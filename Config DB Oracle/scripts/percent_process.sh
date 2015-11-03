#!/bin/bash
#================================================================================
#
#  Programa :  percent_process.sh
#
#  Objetivo :  Informa se a quantidade de processos  está perto do limite configurado.
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
set trim on;
set flush off;
set pagesize 0 

with processos as (select count(*) qt from v\$process) 
select round((processos.qt / x.value)*100,0) from v\$parameter x,processos where x.name='processes';
quit
EOF
}
# check
NUM=$(check)
echo $NUM
