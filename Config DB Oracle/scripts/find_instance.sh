#!/bin/bash
#================================================================================
#
#  Programa :  find_instance.sh
#
#  Objetivo :  Listar as instancias existentes no ambiente.
#
#================================================================================

INSTANCELISTNAME=$(cat /etc/zabbix/zabbix_agentd.d/scripts/4linux_parameters.txt | cut -d\; -f2 | tail -1)
for instancename in ${INSTANCELISTNAME}; do
    instancelist="$instancelist,"'{"{#INSTANCENAME}":"'$instancename'"}'
done
echo '{"data":['${instancelist#,}' ]}'
