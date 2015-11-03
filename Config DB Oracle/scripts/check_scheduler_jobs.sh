#!/bin/bash
#================================================================================
#
#  Programa :  check_scheduler_jobs.sh
#
#  Objetivo :  Checar se existe algum scheduler com falha na execução.
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

-- Scheduler_Jobs   > 0 problema

select count(*) retorno
   from dba_scheduler_jobs a, dba_scheduler_job_run_details b
where a.job_name = b.job_name
  and a.enabled = 'TRUE'
  and b.status <> 'SUCCEEDED'
  and b.log_date = ( 
                     select max(c.log_date)
                        from dba_scheduler_job_run_details c
                     where c.job_name = b.job_name 
                   )
/

EOF
}
check | grep "0" >> /dev/null

if [ "$?" = "0" ];  then 
	echo 0 
else 
 	echo 1 
fi 
