
/*
eventuate db for light-eventuate-4j framework event store
 */
create database eventuate;
GRANT ALL PRIVILEGES ON eventuate.* TO 'mysqluser'@'%' WITH GRANT OPTION;

USE eventuate;

DROP table IF EXISTS events;
DROP table IF EXISTS  entities;
DROP table IF EXISTS  snapshots;

create table events (
  event_id varchar(1000) PRIMARY KEY,
  event_type varchar(1000),
  event_data varchar(1000) NOT NULL,
  entity_type VARCHAR(1000) NOT NULL,
  entity_id VARCHAR(1000) NOT NULL,
  triggering_event VARCHAR(1000),
  metadata VARCHAR(1000),
  published TINYINT DEFAULT 0
);

CREATE INDEX events_idx ON events(entity_type, entity_id, event_id);
CREATE INDEX events_published_idx ON events(published, event_id);

create table entities (
  entity_type VARCHAR(1000),
  entity_id VARCHAR(1000),
  entity_version VARCHAR(1000) NOT NULL,
  PRIMARY KEY(entity_type, entity_id)
);

CREATE INDEX entities_idx ON events(entity_type, entity_id);

create table snapshots (
  entity_type VARCHAR(1000),
  entity_id VARCHAR(1000),
  entity_version VARCHAR(1000),
  snapshot_type VARCHAR(1000) NOT NULL,
  snapshot_json VARCHAR(1000) NOT NULL,
  triggering_events VARCHAR(1000),
  PRIMARY KEY(entity_type, entity_id, entity_version)
);


DROP Table IF Exists message;
DROP Table IF Exists received_messages;
DROP Table IF Exists saga_instance;
DROP Table IF Exists saga_instance_participants;
DROP Table IF Exists aggregate_instance_subscriptions;
DROP Table IF Exists saga_lock_table;
DROP Table IF Exists saga_stash_table;
DROP Table IF Exists saga_enlisted_aggregates;

CREATE TABLE message (
  ID VARCHAR(120),
  DESTINATION VARCHAR(1000) NOT NULL,
  HEADERS VARCHAR(1000) NOT NULL,
  PAYLOAD VARCHAR(1000) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE received_messages (
  CONSUMER_ID VARCHAR(120),
  MESSAGE_ID VARCHAR(120),
  PRIMARY KEY(CONSUMER_ID, MESSAGE_ID)
);

CREATE TABLE saga_instance(
  saga_type VARCHAR(100) NOT NULL,
  saga_id VARCHAR(100) NOT NULL,
  state_name VARCHAR(100) NOT NULL,
  last_request_id VARCHAR(100),
  saga_data_type VARCHAR(1000) NOT NULL,
  saga_data_json VARCHAR(1000) NOT NULL,
  PRIMARY KEY(saga_type, saga_id)
);


CREATE TABLE saga_instance_participants (
  saga_type VARCHAR(100) NOT NULL,
  saga_id VARCHAR(100) NOT NULL,
  destination VARCHAR(100) NOT NULL,
  resource VARCHAR(100) NOT NULL,
  PRIMARY KEY(saga_type, saga_id, destination, resource)
);

CREATE TABLE aggregate_instance_subscriptions(
  aggregate_type VARCHAR(100) DEFAULT NULL,
  aggregate_id VARCHAR(100) NOT NULL,
  event_type VARCHAR(100) NOT NULL,
  saga_id VARCHAR(100) NOT NULL,
  saga_type VARCHAR(100) NOT NULL,
  PRIMARY KEY(aggregate_id, event_type, saga_id, saga_type)
);

create table saga_lock_table(
  target VARCHAR(100),
  saga_type VARCHAR(100) NOT NULL,
  saga_Id VARCHAR(100) NOT NULL,
  PRIMARY KEY(target)
);

create table saga_stash_table(
  message_id VARCHAR(100),
  target VARCHAR(100) NOT NULL,
  saga_type VARCHAR(100) NOT NULL,
  saga_id VARCHAR(100) NOT NULL,
  message_headers VARCHAR(1000) NOT NULL,
  message_payload VARCHAR(1000) NOT NULL,
  PRIMARY KEY(message_id)
  );

create table saga_enlisted_aggregates(
  saga_id VARCHAR(100) NOT NULL,
  aggregate_id VARCHAR(100) NOT NULL,
  aggregate_type VARCHAR(100) DEFAULT NULL,
  PRIMARY KEY(aggregate_id,  saga_id)
  );
