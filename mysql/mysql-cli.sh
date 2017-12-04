#! /bin/bash -e

docker run $* \
   --name mysqlterm --link mysql_1:mysql --rm mysql:5.7 \
   sh -c 'exec mysql -h"$MYSQL_ROOT_PASSWORD" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" -o "$MYSQL_ENV_DATABASE"'