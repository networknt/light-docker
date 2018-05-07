create database todo_db;

GRANT ALL PRIVILEGES ON todo_db.* TO 'mysqluser'@'%' WITH GRANT OPTION;

use todo_db;

DROP table IF EXISTS  TODO;


CREATE  TABLE TODO (
  ID varchar(255),
  TITLE varchar(255),
  COMPLETED BOOLEAN,
  ORDER_ID INTEGER,
  ACTIVE_FLG varchar(1) DEFAULT 'Y',
  PRIMARY KEY(ID)
);
