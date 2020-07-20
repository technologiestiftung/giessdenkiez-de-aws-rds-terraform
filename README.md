# giessdenkiez.de DB provisioning

These are some scripts and tools to setup a Postgres DB and provision the needed tables for the giessdenkiez.de project.


## Prerequisites

- Docker

## Usage

```bash
docker-compose up
# start a session in the container
# the name of the container can be set in the docker-compose.yml
docker exec -it postgresdb /bin/bash
cd /provisioning
# the user, db and password can be set in the docker-compose.yml
#
# !Beware! if you change the POSTGRES_USER environment variable
# you will have to adjust the script /provisioning/dump.sql as well
#
psql -h localhost -d trees -U fangorn -a -q -f ./build-schema.sql
psql -h localhost -d trees -U fangorn -a -q -f ./seed-some-trees.sql
```

