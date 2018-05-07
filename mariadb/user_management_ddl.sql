DROP DATABASE IF EXISTS user;
CREATE DATABASE user;

GRANT ALL PRIVILEGES ON user.* TO 'mysqluser'@'%' WITH GRANT OPTION;

USE user;

DROP TABLE IF EXISTS user_detail;
DROP TABLE IF EXISTS  address;
DROP TABLE IF EXISTS  confirmation_token;


CREATE  TABLE user_detail (
  user_id varchar(256) not null,
  email varchar(100),
  host varchar(100),
  timezone varchar(60),
  screen_name varchar(120),
  first_name varchar(60),
  last_name varchar(60),
  gender  varchar(20),
  birthday date,
  password_hash  varchar(120),
  password_salt  varchar(120),
  locale  varchar(60),
  confirmed varchar(1) DEFAULT 'N',
  locked varchar(1),
  deleted varchar(1),
  createBy varchar(256),
  createdAt date,
  modifiedBy varchar(256),
  modifiedAt date,
  PRIMARY KEY(user_id)
);

CREATE  TABLE address (
   user_id varchar(256) not null,
   address_type varchar(20),
   country varchar(120),
   province_state varchar(120),
   city varchar(120),
   zipcode varchar(20),
   address_line1 varchar(256),
   address_line2 varchar(256),
   active_flg varchar(1) DEFAULT 'Y',
   PRIMARY KEY(user_id, address_type)
);

CREATE  TABLE confirmation_token (
  id varchar(256) not null,
  user_id varchar(256) not null,
  token_type varchar(30),
  valid varchar(1) DEFAULT 'Y',
  payload varchar(400),
  expiresAt timestamp,
  usedAt date,
  PRIMARY KEY(id)
);


