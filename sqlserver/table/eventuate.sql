

CREATE DATABASE eventuate;
GO

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
GO