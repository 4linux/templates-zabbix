#!/bin/bash

HOST=$(cut -d: -f1 /var/lib/zabbix/.pgpass)
SUSER=$(cut -d: -f4 /var/lib/zabbix/.pgpass)
DATABASE=$(cut -d: -f3 /var/lib/zabbix/.pgpass)
DBNAME=$1
OPTION=$2
ERROR_LOG=/var/lib/zabbix/pgsql_conn.error

function showerror {
	echo -e "PostgreSQL connection error: $1" 1>&2
}

if [[ $# -ne 2 ]]; then
	showerror "Número de parâmetros inválidos: $#"
	exit 1
fi

case $OPTION in
	backends)
		QUERY="SELECT numbackends from pg_stat_database WHERE datname = '$DBNAME'"
		;;
	commits)
		QUERY="SELECT xact_commit from pg_stat_database WHERE datname = '$DBNAME'"
		;;
	rollbacks)
		QUERY="SELECT xact_rollback from pg_stat_database WHERE datname = '$DBNAME'"
		;;
	blks_read)
		QUERY="SELECT blks_read from pg_stat_database WHERE datname = '$DBNAME'"
		;;
	blks_hit)
		QUERY="SELECT blks_hit from pg_stat_database WHERE datname = '$DBNAME'"
		;;
	returns)
		QUERY="SELECT tup_returned from pg_stat_database WHERE datname = '$DBNAME'"
		;;
	fetches)
		QUERY="SELECT tup_fetched from pg_stat_database WHERE datname = '$DBNAME'"
		;;
	inserts)
		QUERY="SELECT tup_inserted from pg_stat_database WHERE datname = '$DBNAME'"
		;;
	updates)
		QUERY="SELECT tup_updated from pg_stat_database WHERE datname = '$DBNAME'"
		;;
	deletes)
		QUERY="SELECT tup_deleted from pg_stat_database WHERE datname = '$DBNAME'"
		;;
	size)
		QUERY="SELECT pg_database_size('$DBNAME');"
		;;
	*)
		showerror "opção '$OPTION' inválida."
		exit 1
esac

psql -U $SUSER -h $HOST -c "$QUERY" $DATABASE -tA 2> $ERROR_LOG

if [[ $? -ne 0 ]]; then
	showerror "Erro ao executar consulta: $(cat $ERROR_LOG)"
	exit 1
fi

exit 0
