This is a docker image for mysql which is used for postfix email installation

## Databases

### postfix db

postfix.sql is used to create hardware/emailserver tables.


## Compose

There is a docker-compose.yml file in the directory. Please update the passwords
for root and mysqluser before running the compose to start mysql.

```
docker-compose up
```

## Console

You can use mysql cli to connect to mysql database from your host.
