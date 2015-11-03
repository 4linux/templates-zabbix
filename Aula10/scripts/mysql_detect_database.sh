#!/bin/bash
LIST_DATABSE=`echo "select distinct db from mysql.db where db not like '%test%';" | HOME=/var/lib/zabbix mysql -N`

FIRST_ELEMENT=1

function json_head {
    printf "{";
    printf "\"data\":[";    
}

function json_end {
    printf "]";
    printf "}";
}

function check_first_element {
    if [[ $FIRST_ELEMENT -ne 1 ]]; then
        printf ","
    fi
    FIRST_ELEMENT=0
}

function databse_detect {
    json_head
    for dbname in $LIST_DATABSE
    do
        local dbname_t=$(echo $dbname| sed 's!\n!!g')
        check_first_element
        printf "{"
        printf "\"{#DBNAME}\":\"$dbname_t\""
        printf "}"
    done
    json_end
}
databse_detect
