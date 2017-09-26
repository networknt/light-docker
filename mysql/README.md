This is a docker image for mysql which is used for multiple places in side of
infrastructure of light-*-4j frameworks and applications.

Here is the customized features.

### enable replication

light-eventuate-4j uses this instance for CDC (change data capture) with Mysql
binlog. The replication.cnf is the config file to enable binlog.

### eventuate db

eventuate.sql is used to create eventuate db for the event store of light-eventuate-4j framework. 

### oauth2 db

oauth2.sql is used to create tables for light-oauth2 service providers.

### postfix db

postfix.sql is used to create hardware/emailserver tables.

### todo db

todo_db.sql is used to create todo_list example database tables.

 