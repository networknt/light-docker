create database customerorder;

GRANT ALL PRIVILEGES ON customerorder.* TO 'mysqluser'@'%' WITH GRANT OPTION;

use customerorder;

DROP table IF EXISTS  customer;
DROP table IF EXISTS  order_detail;


CREATE  TABLE customer (
  customer_id long,
  name varchar(255),
  creditLimit numeric
);

CREATE  TABLE order_detail (
  order_id long ,
  customer_id long,
  state varchar(50),
  amount numeric

);
