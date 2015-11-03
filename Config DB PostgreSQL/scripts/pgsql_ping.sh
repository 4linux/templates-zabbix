#!/bin/bash

HOST=$(cut -d: -f1 /var/lib/zabbix/.pgpass)
SUSER=$(cut -d: -f4 /var/lib/zabbix/.pgpass)
DATABASE=$(cut -d: -f3 /var/lib/zabbix/.pgpass)
QUERY_PING="SELECT 1;"
ERROR_LOG=/var/lib/zabbix/pgsql_ping.error

function showerror {
	echo -e "PostgreSQL ping error: $1" 1>&2
}

PING_OK="1"

echo -e "select 1" | psql -qAtX -h $HOST -U $SUSER $DATABASE 2> $ERROR_LOG > /dev/null

if [[ $? -ne 0 ]]; then
	showerror
else
	echo $PING_OK
fi

exit 0
