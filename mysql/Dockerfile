FROM mysql:5.7
COPY replication.cnf /etc/mysql/conf.d
COPY eventuate.sql /docker-entrypoint-initdb.d
COPY oauth2.sql /docker-entrypoint-initdb.d
COPY todo_db.sql /docker-entrypoint-initdb.d
COPY saga_example.sql /docker-entrypoint-initdb.d
