#!/bin/bash
#================================================================================
#
#  Programa :  tablespace_used.sh
#
#  Objetivo :  Informa a porcentagem de utilização das tablespaces.
#
#================================================================================

# Variables
INSTANCENAME=$(cat /etc/zabbix/zabbix_agentd.d/scripts/4linux_parameters.txt | cut -d\; -f2 | tail -1)
ORACLE_HOME=$(cat /etc/zabbix/zabbix_agentd.d/scripts/4linux_parameters.txt  | grep $INSTANCENAME | cut -d\; -f4)
SYS_SENHA=$(cat /etc/zabbix/zabbix_agentd.d/scripts/4linux_parameters.txt  | grep $INSTANCENAME | cut -d\; -f6)
TABLESPACENAME=$2

function check { 
export ORACLE_HOME="${ORACLE_HOME}"
export ORACLE_SID="${INSTANCENAME}"
$ORACLE_HOME/bin/sqlplus -S /nolog << EOF

connect sys/$SYS_SENHA as sysdba

set echo off
set feedback off
set linesize 1000 
set trimspool on 
set heading off
set feedback off
set echo off
set trim on
set flush off
select Trunc(used_percent,0) from  dba_tablespace_usage_metrics where tablespace_name = '${TABLESPACENAME}';
exit 

EOF
}
RESULT=$(check)
echo $RESULT
