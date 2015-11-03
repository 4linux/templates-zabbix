#!/bin/bash
#================================================================================
#
#  Programa :  check_lock.sh
#
#  Objetivo :  Checar se existem transações aguardando loks do tipo TX ou SX.
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
set flush off;
set pagesize 0

select LTrim (sign (count(type))) from gv\$lock where type in ('TX','SX') and CTIME > 250;
EOF

exit
}
check
