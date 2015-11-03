#!/bin/bash

HOST=$(cut -d: -f1 /var/lib/zabbix/.pgpass)
SUSER=$(cut -d: -f4 /var/lib/zabbix/.pgpass)
DATABASE=$(cut -d: -f3 /var/lib/zabbix/.pgpass)
OPTION=$1
ERROR_LOG=/var/lib/zabbix/pgsql_conn.error

function showerror {
	echo -e "PostgreSQL connection error: $1" 1>&2
}


if [[ $# -eq 0 ]]; then
	showerror "Parâmetro obrigatório omitido"
	exit 1
fi

case $OPTION in
	max)
		QUERY="SELECT setting FROM pg_settings where name = 'max_connections';"
		;;
	count)
		QUERY="SELECT count(*) FROM pg_stat_activity;"
		;;
	idle)
		QUERY="SELECT count(*) FROM pg_stat_activity WHERE state = '<IDLE>';"
		;;
	idle_in_trans)
		QUERY="SELECT count(*) FROM pg_stat_activity WHERE state = '<IDLE> in transaction';"
		;;
	running)
		QUERY="SELECT count(*) FROM pg_stat_activity WHERE state NOT LIKE '<IDLE%>';"
		;;
	oldest)
		QUERY="SELECT floor(date_part('epoch', backend_start)) as oldest FROM pg_stat_activity order by 1 desc limit 1;"
		;;
	waiting)
		QUERY="SELECT count(*) FROM pg_stat_activity where waiting;"
		;;
	not_waiting)
		QUERY="SELECT count(*) FROM pg_stat_activity where not waiting;"
		;;

	ExclusiveLock)
		QUERY="SELECT count(*) FROM pg_locks where mode='ExclusiveLock';"
		;;
	AccessExclusiveLock)
		QUERY="SELECT count(*) FROM pg_locks where mode='AccessExclusiveLock';"
		;;
	AccessShareLock)
		QUERY="SELECT count(*) FROM pg_locks where mode='AccessShareLock';"
		;;
	RowShareLock)
		QUERY="SELECT count(*) FROM pg_locks where mode='RowShareLock';"
		;;
	RowExclusiveLock)
		QUERY="SELECT count(*) FROM pg_locks where mode='RowExclusiveLock';"
		;;
	ShareUpdateExclusiveLock)
		QUERY="SELECT count(*) FROM pg_locks where mode='ShareUpdateExclusiveLock';"
		;;
	ShareRowExclusiveLock)
		QUERY="SELECT count(*) FROM pg_locks where mode='ShareRowExclusiveLock';"
		;;
	checkpoints_timed)
		QUERY="SELECT checkpoints_timed FROM pg_stat_bgwriter;"
		;;
	checkpoints_req)
		QUERY="SELECT checkpoints_req FROM pg_stat_bgwriter;"
		;;
	buffers_checkpoint)
		QUERY="SELECT buffers_checkpoint FROM pg_stat_bgwriter;"
		;;
	buffers_clean)
		QUERY="SELECT buffers_clean FROM pg_stat_bgwriter;"
		;;
	maxwritten_clean)
		QUERY="SELECT maxwritten_clean FROM pg_stat_bgwriter;"
		;;
	buffers_backend)
		QUERY="SELECT buffers_backend FROM pg_stat_bgwriter;"
		;;
	buffers_alloc)
		QUERY="SELECT buffers_alloc FROM pg_stat_bgwriter;"
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
