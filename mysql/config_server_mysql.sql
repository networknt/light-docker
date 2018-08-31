DROP DATABASE IF EXISTS config;
CREATE DATABASE config;

GRANT ALL PRIVILEGES ON config.* TO 'mysqluser'@'%' WITH GRANT OPTION;

USE config;

DROP TABLE IF EXISTS config_value;
DROP TABLE IF EXISTS config_service;


CREATE TABLE config_value (
  config_key VARCHAR(256) NOT NULL,
  config_value VARCHAR(256) NOT NULL,
  config_service_id VARCHAR(256) NOT NULL,
  PRIMARY KEY (config_key, config_service_id)
)
ENGINE=INNODB;




CREATE TABLE config_service (
  config_service_id VARCHAR(256) NOT NULL,
  service_profile VARCHAR(256) NOT NULL,
  service_id VARCHAR(256) NOT NULL,
  service_version VARCHAR(256) ,
  encryptio_algorithm VARCHAR(32),
  encryption_salt VARCHAR(256),
  template_repository VARCHAR(256) ,
  service_owner VARCHAR(32),
  refreshed varchar(1) DEFAULT 'N',
  PRIMARY KEY ( config_service_id)
)
ENGINE=INNODB;
