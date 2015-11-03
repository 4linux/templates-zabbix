#!/bin/bash
DBNAME=$1
OPTION=$2

function showerror {
	echo -e "MYSQL connection error: $1" 
}

if [[ $# -ne 2 ]]; then
	showerror "Número de parâmetros inválidos: $#"
	exit 1
fi

case $OPTION in
	total_size)
		QUERY="SELECT concat(round(sum(DATA_LENGTH+INDEX_LENGTH)/1024/1024,2)) as data FROM information_schema.TABLES where TABLE_SCHEMA='$DBNAME';"
		;;
	total_table)
		QUERY="SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = '$DBNAME';"
		;;
	*)
		showerror "opção '$OPTION' inválida."
		exit 1
esac

echo "$QUERY" | HOME=/var/lib/zabbix mysql -N

if [[ $? -ne 0 ]]; then
	showerror "Erro ao executar consulta: $(cat $ERROR_LOG)"
	exit 1
fi

exit 0
