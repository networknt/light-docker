This folder contains description for docker-compose-api.yml file for api VM
in the parent folder. 

## DOCKER_HOST_IP

Before starting the docker-compose command, please make sure the the following command
is executed on the host.

```
export DOCKER_HOST_IP=XX.XX.XX.XX
```

or put the command in .profile under your user directory.

## To start all services

To start all services in background, start with -d option. Otherwise, remove the -d

```
cd ~/networknt
cd light-docker
docker-compose -f docker-compose-api.yml up -d
```

## Components

* Jenkins Master
* Gogs
* Mysql
* Arango
* Consul
* Confluent
* ELK
* Influx and Grafana
* CDC server
* Hybrid-query server
* Hybrid-command server


