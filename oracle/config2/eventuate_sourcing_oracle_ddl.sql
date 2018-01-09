
CREATE TABLESPACE tbs_perm_01
  DATAFILE 'tbs_perm_01.dat'
    SIZE 10M
    REUSE
    AUTOEXTEND ON NEXT 10M MAXSIZE 200M;

CREATE USER EVENTUATE
  IDENTIFIED BY password
  DEFAULT TABLESPACE tbs_perm_01
  QUOTA 20M on tbs_perm_01;

CREATE USER TRAM
  IDENTIFIED BY password
  DEFAULT TABLESPACE tbs_perm_01
  QUOTA 20M on tbs_perm_01;
--DROP table EVENTUATE.events;
--DROP table EVENTUATE.entities;
--DROP table EVENTUATE.snapshots;

create table EVENTUATE.events (
  event_id varchar(1000) PRIMARY KEY,
  event_type varchar(1000),
  event_data varchar(1000) NOT NULL,
  entity_type VARCHAR(1000) NOT NULL,
  entity_id VARCHAR(1000) NOT NULL,
  triggering_event VARCHAR(1000),
  metadata VARCHAR(1000),
  published INT DEFAULT 0
);

CREATE INDEX EVENTUATE.events_idx ON EVENTUATE.events(entity_type, entity_id, event_id);
CREATE INDEX EVENTUATE.events_published_idx ON EVENTUATE.events(published, event_id);

create table EVENTUATE.entities (
  entity_type VARCHAR(1000),
  entity_id VARCHAR(1000),
  entity_version VARCHAR(1000) NOT NULL,
  PRIMARY KEY(entity_type, entity_id)
);


create table EVENTUATE.snapshots (
  entity_type VARCHAR(1000),
  entity_id VARCHAR(1000),
  entity_version VARCHAR(1000),
  snapshot_type VARCHAR(1000) NOT NULL,
  snapshot_json VARCHAR(1000) NOT NULL,
  triggering_events VARCHAR(1000),
  PRIMARY KEY(entity_type, entity_id, entity_version)
);

CREATE TABLE TRAM.message (
  ID VARCHAR(120) PRIMARY KEY,
  DESTINATION VARCHAR(1000) NOT NULL,
  HEADERS VARCHAR(1000) NOT NULL,
  PAYLOAD VARCHAR(1000) NOT NULL,
  PUBLISHED INT DEFAULT 0
);

CREATE TABLE TRAM.received_messages (
  CONSUMER_ID VARCHAR(120),
  MESSAGE_ID VARCHAR(120),
  PRIMARY KEY(CONSUMER_ID, MESSAGE_ID)
);

CREATE TABLE EVENTUATE.saga_instance(
  saga_type VARCHAR(100) NOT NULL,
  saga_id VARCHAR(100) NOT NULL,
  state_name VARCHAR(100) NOT NULL,
  last_request_id VARCHAR(100),
  saga_data_type VARCHAR(1000) NOT NULL,
  saga_data_json VARCHAR(1000) NOT NULL,
  PRIMARY KEY(saga_type, saga_id)
);


CREATE TABLE EVENTUATE.saga_instance_participants (
  saga_type VARCHAR(100) NOT NULL,
  saga_id VARCHAR(100) NOT NULL,
  destination VARCHAR(100) NOT NULL,
  resource_name VARCHAR(100) NOT NULL,
  PRIMARY KEY(saga_type, saga_id, destination, resource_name)
);

CREATE TABLE EVENTUATE.aggre_instance_subscriptions(
  aggregate_type VARCHAR(100) DEFAULT NULL,
  aggregate_id VARCHAR(100) NOT NULL,
  event_type VARCHAR(100) NOT NULL,
  saga_id VARCHAR(100) NOT NULL,
  saga_type VARCHAR(100) NOT NULL,
  PRIMARY KEY(aggregate_id, event_type, saga_id, saga_type)
);

create table EVENTUATE.saga_lock_table(
  target VARCHAR(100) NOT NULL,
  saga_type VARCHAR(100) NOT NULL,
  saga_Id VARCHAR(100) NOT NULL,
  PRIMARY KEY(target)
);

create table EVENTUATE.saga_stash_table(
  message_id VARCHAR(100) NOT NULL,
  target VARCHAR(100) NOT NULL,
  saga_type VARCHAR(100) NOT NULL,
  saga_id VARCHAR(100) NOT NULL,
  message_headers VARCHAR(1000) NOT NULL,
  message_payload VARCHAR(1000) NOT NULL,
  PRIMARY KEY(message_id)
  );

create table EVENTUATE.saga_enlisted_aggregates(
  saga_id VARCHAR(100) NOT NULL,
  aggregate_id VARCHAR(100) NOT NULL,
  aggregate_type VARCHAR(100) DEFAULT NULL,
  PRIMARY KEY(aggregate_id,  saga_id)
  );


CREATE OR REPLACE  SYNONYM SYSTEM.snapshots FOR EVENTUATE.snapshots;
CREATE OR REPLACE  SYNONYM SYSTEM.entities FOR EVENTUATE.entities;
CREATE OR REPLACE  SYNONYM SYSTEM.events FOR EVENTUATE.events;

CREATE OR REPLACE  SYNONYM SYSTEM.message FOR TRAM.message;
CREATE OR REPLACE  SYNONYM SYSTEM.received_messages FOR TRAM.received_messages;

CREATE OR REPLACE  SYNONYM SYSTEM.saga_instance FOR EVENTUATE.saga_instance;
CREATE OR REPLACE  SYNONYM SYSTEM.saga_instance_participants FOR EVENTUATE.saga_instance_participants;
CREATE OR REPLACE  SYNONYM SYSTEM.aggre_instance_subscriptions FOR EVENTUATE.aggre_instance_subscriptions;
CREATE OR REPLACE  SYNONYM SYSTEM.saga_lock_table FOR EVENTUATE.saga_lock_table;
CREATE OR REPLACE  SYNONYM SYSTEM.saga_stash_table FOR EVENTUATE.saga_stash_table;
CREATE OR REPLACE  SYNONYM SYSTEM.saga_enlisted_aggregates FOR EVENTUATE.saga_enlisted_aggregates;