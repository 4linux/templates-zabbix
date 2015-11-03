#!/bin/bash 
#================================================================================
#
#  Programa :  lsnrctl_status.sh
#
#  Objetivo :  Verifica o status do LISTENER.
#
#================================================================================

INSTANCENAME=$(cat /etc/zabbix/zabbix_agentd.d/scripts/4linux_parameters.txt | cut -d\; -f2 | tail -1)

# Listener
for X in $INSTANCENAME ; do LAST=${X} ; done
ORACLE_HOME=$(cat /etc/zabbix/zabbix_agentd.d/scripts/4linux_parameters.txt  | grep -i ${LAST} | cut -d\; -f4)

export ORACLE_HOME=${ORACLE_HOME}

${ORACLE_HOME}/bin/lsnrctl $1 $2 >> /dev/null 2>> /dev/null
if [ $? -eq 0 ] ; then
		echo 0 
else 
		echo 1 

fi 
