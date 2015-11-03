1) Antes de adicionar o template 24 - Template 4Linux DB MySQL.xml, é necessário adicionar um "Value Mapping" no Zabbix.

2) Como Administrador acesse a interface web e entre em Administration > General e Selecione Value Mapping no canto direito superior.

3) Adicione com os seguintes dados:

	NOME: 4Linux Default MAP
	VALUE		MAPPED TO
	0		OK
	1		Falha

4) Crie o diretório scripts.

	# mkdir /etc/zabbix/zabbix_agentd.d/scripts

5) Copie os scripts para dentro do diretório recem criado e altere o proprietário da pasta para o usuário Zabbix

	# cp *.sh /etc/zabbix/zabbix_agentd.d/scripts
	# chown zabbix. /etc/zabbix/zabbix_agentd.d/scripts -R
	# chmod 750 /etc/zabbix/zabbix_agentd.d/scripts/*

6) Edite o script /etc/zabbix/zabbix_agentd.d/scripts/mysql_db_status.sh, deixando a linha:

	echo "$QUERY" | HOME=....

Da seguinte forma:

	echo “$QUERY” | HOME=/var/lib/zabbix mysql -uroot -p4linux ­-N

e /etc/zabbix/zabbix_agentd.d/scripts/mysql_detect_database.sh

Da seguinte forma: 

	LIST_DATABSE=`echo “select distinct db from mysql.db db not like '%test%';” | HOME=/var/lib/zabbix mysql -uroot -p4linux -N`

9) Por último reinicie o serviço Agent do Zabbix.

	# service zabbix-agent restart
