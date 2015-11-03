#!/bin/bash
#================================================================================
#
#  Programa :  find_alert_log.sh 
#
#  Objetivo :  Checar erros no alert_log.
#
#================================================================================

GETINSTANCE=$(cat /etc/zabbix/zabbix_agentd.d/scripts/4linux_parameters.txt | cut -d\; -f2 | tail -1)

for instancename in $GETINSTANCE; do
	ALERT_LOG=$(cat /etc/zabbix/zabbix_agentd.d/scripts/4linux_parameters.txt  | grep -v ^# | grep $instancename | cut -d\; -f3 )
	FILTRO_LOG=$(find $ALERT_LOG -iname *.log)
# Altera variavel para coleta apenas tablespace necessarias
        for filesname in $FILTRO_LOG; do
            alert_logs_instance_names="$alert_logs_instance_names,"'{"{#ALERTLOGFILE}":"'$filesname'","{#INSTANCENAME}":"'$instancename'"}'
        done

done
echo '{"data":['${alert_logs_instance_names#,}' ]}'
