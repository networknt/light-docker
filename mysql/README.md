This is a docker image for mysql which is used for multiple places in side of
infrastructure of light-*-4j frameworks and applications.

## Databases

### enable replication

light-eventuate-4j uses this instance for CDC (change data capture) with Mysql
binlog. The replication.cnf is the config file to enable binlog.

### eventuate db

eventuate.sql is used to create eventuate db for the event store of light-eventuate-4j framework. 

### oauth2 db

oauth2.sql is used to create tables for light-oauth2 service providers.

### todo db

todo_db.sql is used to create todo_list example database tables.


## Compose

There is a docker-compose.yml file in the directory. Please update the passwords
for root and mysqluser before running the compose to start mysql.

```
docker-compose up
```

## Console

You can use mysql cli to connect to mysql database from your host.


## Recreate Database

```
docker-compose -f docker-compose-mysql.yml down --rmi all
```

The above command will remove all the existing databases and recreate from the script again. 

