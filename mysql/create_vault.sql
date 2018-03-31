/*
This is the defult vault database and you can create as many as you want for the
same tokenization instance.
 */
DROP DATABASE IF EXISTS vault000;
CREATE DATABASE vault000;

GRANT ALL PRIVILEGES ON vault000.* TO 'mysqluser'@'%' WITH GRANT OPTION;

USE vault000;

DROP TABLE IF EXISTS token_vault;

CREATE TABLE token_vault (
  id VARCHAR(1024) NOT NULL,
  value VARCHAR(1024) NOT NULL,
  PRIMARY KEY (id)
)
ENGINE=INNODB;


CREATE INDEX value_idx ON token_vault(value);
