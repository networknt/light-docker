# light-docker
Dockerfile and compose to bring everything up together with your APIs

# Docker API


# Docker Light OAuth2

The oauth2 server uses json files for clients and users registration and these files can be externalized.

If you want to use the default clients and users for testing.

```
docker run -d -p 8888:8888 networknt/oauth2-server
```
If you want to add more users and clients for your development, please create a folder and copy clients.json and users.json and add more entries.
```
docker run -d -v /home/steve/tmp/config/oauth2:/config -p 8888:8888 networknt/oauth2-server
```
For more info on how to use it, please refer to https://github.com/networknt/undertow-server-oauth2

or watch the following two videos.

How to start the oauth2 server in docker container

https://youtu.be/w0a8f0hJVmU

How to customize the oauth2 server

https://youtu.be/eq1BxjDFg6o

# Docker Grafana

This project builds a Docker image with the latest master build of Grafana.

## Running your Grafana container

Start your container binding the external port `3000`.

```
docker run -d --name=grafana -p 3000:3000 grafana/grafana
```

Try it out, default admin user is admin/admin.

## Configuring your Grafana container

All options defined in conf/grafana.ini can be overriden using environment
variables by using the syntax `GF_<SectionName>_<KeyName>`.  
For example:

```
docker run \
  -d \
  -p 3000:3000 \
  --name=grafana \
  -e "GF_SERVER_ROOT_URL=http://grafana.server.name" \
  -e "GF_SECURITY_ADMIN_PASSWORD=secret" \
  grafana/grafana
```

More information in the grafana configuration documentation: http://docs.grafana.org/installation/configuration/

## Grafana container with persistent storage (recommended)

```
# create /var/lib/grafana as persistent volume storage
docker run -d -v /var/lib/grafana --name grafana-storage busybox:latest

# start grafana
docker run \
  -d \
  -p 3000:3000 \
  --name=grafana \
  --volumes-from grafana-storage \
  grafana/grafana
```

## Installing plugins for Grafana 3

Pass the plugins you want installed to docker with the `GF_INSTALL_PLUGINS` environment variable as a comma seperated list. This will pass each plugin name to `grafana-cli plugins install ${plugin}`.

```
docker run \
  -d \
  -p 3000:3000 \
  --name=grafana \
  -e "GF_INSTALL_PLUGINS=grafana-clock-panel,grafana-simple-json-datasource" \
  grafana/grafana
```

## Running specific version of Grafana

```
# specify right tag, e.g. 2.6.0 - see Docker Hub for available tags
docker run \
  -d \
  -p 3000:3000 \
  --name grafana \
  grafana/grafana:2.6.0
```

## Configuring AWS credentials for CloudWatch support

```
docker run \
  -d \
  -p 3000:3000 \
  --name=grafana \
  -e "GF_AWS_PROFILES=default" \
  -e "GF_AWS_default_ACCESS_KEY_ID=YOUR_ACCESS_KEY" \
  -e "GF_AWS_default_SECRET_ACCESS_KEY=YOUR_SECRET_KEY" \
  -e "GF_AWS_default_REGION=us-east-1" \
  grafana/grafana
```

You may also specify multiple profiles to `GF_AWS_PROFILES` (e.g.
`GF_AWS_PROFILES=default another`).

Supported variables:

- `GF_AWS_${profile}_ACCESS_KEY_ID`: AWS access key ID (required).
- `GF_AWS_${profile}_SECRET_ACCESS_KEY`: AWS secret access  key (required).
- `GF_AWS_${profile}_REGION`: AWS region (optional).

# Docker Influxdb 

Usage
-----

To create the image `tutum/influxdb`, execute the following command on tutum-docker-influxdb folder:

    docker build -t tutum/influxdb .

You can now push new image to the registry:

    docker push tutum/influxdb

Tags
----

    tutum/influxdb:latest -> influxdb 1.0
    tutum/influxdb:0.13   -> influxdb 0.13.x
    tutum/influxdb:0.12   -> influxdb 0.12.x
    tutum/influxdb:0.10   -> influxdb 0.10.x
    tutum/influxdb:0.9    -> influxdb 0.9.x
    tutum/influxdb:0.8.8  -> influxdb 0.8.8

Running your InfluxDB image
---------------------------

Start your image binding the external ports `8083` and `8086` in all interfaces to your container. Ports `8090` and `8099` are only used for clustering and should not be exposed to the internet:

    docker run -d -p 8083:8083 -p 8086:8086 tutum/influxdb

`Docker` containers are easy to delete. If you delete your container instance and your cluster goes offline, you'll lose the InfluxDB store and configuration. If you are serious about keeping InfluxDB data persistently, then consider adding a volume mapping to the containers `/data` folder:

    docker run -d --volume=/var/influxdb:/data -p 8083:8083 -p 8086:8086 tutum/influxdb

**Note**: `influxdb:0.9` is **NOT** backwards compatible with `0.8.x`. If you need version `0.8.x`, please run:

    docker run -d -p 8083:8083 -p 8086:8086 tutum/influxdb:0.8.8

Configuring your InfluxDB
-------------------------
Open your browser to access `localhost:8083` to configure InfluxDB. Fill the port which maps to `8086`. *There is no default user anymore in version 0.9 but you can set `auth-enabled: true` in the config.toml.*

Alternatively, you can use RESTful API to talk to InfluxDB on port `8086`. For example, if you have problems with the initial database creation for version `0.9.x`, you can use the new `influx` cli tool to configure the database. While the container is running, you launch the tool with the following command:

  ```
  docker exec -ti influxdb-container-name /usr/bin/influx
  Visit https://enterprise.influxdata.com to register for updates, InfluxDB server management, and monitoring.
  Connected to http://localhost:8086 version 0.9.6.1
  InfluxDB shell 0.9.6.1
  >
  ```

Initially create Database
-------------------------
Use `-e PRE_CREATE_DB="db1;db2;db3"` to create database named "db1", "db2", and "db3" on the first time the container starts automatically. Each database name is separated by `;`. For example:

```docker run -d -p 8083:8083 -p 8086:8086 -e ADMIN_USER="root" -e INFLUXDB_INIT_PWD="somepassword" -e PRE_CREATE_DB="db1;db2;db3" tutum/influxdb:latest```

Alternatively, create a database and user with the InfluxDB 0.9 shell:

```
  > CREATE DATABASE db1
  > SHOW DATABASES
  name: databases
  ---------------
  name
  db1
  > USE db1
  > CREATE USER root WITH PASSWORD 'somepassword' WITH ALL PRIVILEGES
  > GRANT ALL PRIVILEGES ON db1 TO root
  > SHOW USERS
  user  admin
  root  true
```
For additional Administration methods with the InfluxDB 0.9 shell, check out the [`Administration`](https://influxdb.com/docs/v0.9/administration/administration.html) guide on the InfluxDB website.


Initially execute influxql script (Available only in influxdb:0.9)
------------------------------------------------------------
Use `-v /tmp/init_script.influxql:init_script.influxql:ro` if you want that script to been executed on the first time the container starts automatically. Each influxql command on separated line. For example:

- Docker run command
```
docker run -d -p 8083:8083 -p 8086:8086 -e ADMIN_USER="root" -e INFLUXDB_INIT_PWD="somepassword" -v /tmp/init_script.influxql:init_script.influxql:ro tutum/influxdb:latest
```

- The influxdb script
```
CREATE DATABASE mydb
CREATE USER writer WITH PASSWORD 'writerpass'
CREATE USER reader WITH PASSWORD 'readerpass'
GRANT WRITE ON mydb TO writer
GRANT READ ON mydb TO reader
```

UDP support
----------------------------------------
If you provide a `UDP_DB`, influx will open a UDP port (4444 or if provided `UDP_PORT`) for reception of events for the named database.

```docker run -d -p 8083:8083 -p 8086:8086 -p 4444:4444/udp --expose 8090 --expose 8099 --expose 4444 -e UDP_DB="my_db" tutum/influxdb```


# Docker ELK stack

Run the latest version of the ELK (Elasticseach, Logstash, Kibana) stack with Docker and Docker-compose.

It will give you the ability to analyze any data set by using the searching/aggregation capabilities of Elasticseach and the visualization power of Kibana.

Based on the official images:

* [elasticsearch](https://registry.hub.docker.com/_/elasticsearch/)
* [logstash](https://registry.hub.docker.com/_/logstash/)
* [kibana](https://registry.hub.docker.com/_/kibana/)

**Note**: Other branches in this project are available:

* ELK 5 with X-Pack support: https://github.com/deviantony/docker-elk/tree/x-pack
* ELK 5 in Vagrant: https://github.com/deviantony/docker-elk/tree/vagrant

# Requirements

## Setup

1. Install [Docker](http://docker.io).
2. Install [Docker-compose](http://docs.docker.com/compose/install/) **version >= 1.6**.
3. Clone this repository

## Increase max_map_count on your host (Linux)

You need to increase `max_map_count` on your Docker host:

```bash
$ sudo sysctl -w vm.max_map_count=262144
```

## SELinux

On distributions which have SELinux enabled out-of-the-box you will need to either re-context the files or set SELinux into Permissive mode in order for docker-elk to start properly.
For example on Redhat and CentOS, the following will apply the proper context:

```bash
.-root@centos ~
-$ chcon -R system_u:object_r:admin_home_t:s0 docker-elk/
```

# Usage

Start the ELK stack using *docker-compose*:

```bash
$ docker-compose up
```

You can also choose to run it in background (detached mode):

```bash
$ docker-compose up -d
```

Now that the stack is running, you'll want to inject logs in it. The shipped logstash configuration allows you to send content via tcp:

```bash
$ nc localhost 5000 < /path/to/logfile.log
```

And then access Kibana UI by hitting [http://localhost:5601](http://localhost:5601) with a web browser.

*NOTE*: You'll need to inject data into logstash before being able to create a logstash index in Kibana. Then all you should have to do is to hit the create button.

See: https://www.elastic.co/guide/en/kibana/current/setup.html#connect

By default, the stack exposes the following ports:
* 5000: Logstash TCP input.
* 9200: Elasticsearch HTTP
* 9300: Elasticsearch TCP transport
* 5601: Kibana

*WARNING*: If you're using *boot2docker*, you must access it via the *boot2docker* IP address instead of *localhost*.

*WARNING*: If you're using *Docker Toolbox*, you must access it via the *docker-machine* IP address instead of *localhost*.

# Configuration

*NOTE*: Configuration is not dynamically reloaded, you will need to restart the stack after any change in the configuration of a component.

## How can I tune Kibana configuration?

The Kibana default configuration is stored in `kibana/config/kibana.yml`.

## How can I tune Logstash configuration?

The logstash configuration is stored in `logstash/config/logstash.conf`.

The folder `logstash/config` is mapped onto the container `/etc/logstash/conf.d` so you
can create more than one file in that folder if you'd like to. However, you must be aware that config files will be read from the directory in alphabetical order.

## How can I specify the amount of memory used by Logstash?

The Logstash container use the *LS_HEAP_SIZE* environment variable to determine how much memory should be associated to the JVM heap memory (defaults to 500m).

If you want to override the default configuration, add the *LS_HEAP_SIZE* environment variable to the container in the `docker-compose.yml`:

```yml
logstash:
  build: logstash/
  command: -f /etc/logstash/conf.d/
  volumes:
    - ./logstash/config:/etc/logstash/conf.d
  ports:
    - "5000:5000"
  links:
    - elasticsearch
  environment:
    - LS_HEAP_SIZE=2048m
```

## How can I add Logstash plugins? ##

To add plugins to logstash you have to:

1. Add a RUN statement to the `logstash/Dockerfile` (ex. `RUN logstash-plugin install logstash-filter-json`)
2. Add the associated plugin code configuration to the `logstash/config/logstash.conf` file

## How can I enable a remote JMX connection to Logstash?

As for the Java heap memory, another environment variable allows to specify JAVA_OPTS used by Logstash. You'll need to specify the appropriate options to enable JMX and map the JMX port on the docker host.

Update the container in the `docker-compose.yml` to add the *LS_JAVA_OPTS* environment variable with the following content (I've mapped the JMX service on the port 18080, you can change that), do not forget to update the *-Djava.rmi.server.hostname* option with the IP address of your Docker host (replace **DOCKER_HOST_IP**):

```yml
logstash:
  build: logstash/
  command: -f /etc/logstash/conf.d/
  volumes:
    - ./logstash/config:/etc/logstash/conf.d
  ports:
    - "5000:5000"
  links:
    - elasticsearch
  environment:
    - LS_JAVA_OPTS=-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.port=18080 -Dcom.sun.management.jmxremote.rmi.port=18080 -Djava.rmi.server.hostname=DOCKER_HOST_IP -Dcom.sun.management.jmxremote.local.only=false
```

## How can I tune Elasticsearch configuration?

The Elasticsearch container is using the shipped configuration and it is not exposed by default.

If you want to override the default configuration, create a file `elasticsearch/config/elasticsearch.yml` and add your configuration in it.

Then, you'll need to map your configuration file inside the container in the `docker-compose.yml`. Update the elasticsearch container declaration to:

```yml
elasticsearch:
  build: elasticsearch/
  ports:
    - "9200:9200"
    - "9300:9300"
  environment:
    ES_JAVA_OPTS: "-Xms1g -Xmx1g"
  volumes:
    - ./elasticsearch/config/elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml
```

You can also specify the options you want to override directly in the command field:

```yml
elasticsearch:
  build: elasticsearch/
  command: elasticsearch -Des.network.host=_non_loopback_ -Des.cluster.name: my-cluster
  ports:
    - "9200:9200"
    - "9300:9300"
  environment:
    ES_JAVA_OPTS: "-Xms1g -Xmx1g"
```

# Storage

## How can I store Elasticsearch data?

The data stored in Elasticsearch will be persisted after container reboot but not after container removal.

In order to persist Elasticsearch data even after removing the Elasticsearch container, you'll have to mount a volume on your Docker host. Update the elasticsearch container declaration to:

```yml
elasticsearch:
  build: elasticsearch/
  ports:
    - "9200:9200"
    - "9300:9300"
  environment:
    ES_JAVA_OPTS: "-Xms1g -Xmx1g"
  volumes:
    - /path/to/storage:/usr/share/elasticsearch/data
```

This will store elasticsearch data inside `/path/to/storage`.
