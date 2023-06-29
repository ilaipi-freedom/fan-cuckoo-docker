#!/bin/sh

docker build -t ilaipi/cuckoo:1.0 .

docker volume create cuckoo-mongodb-data

docker rm -f cuckoo-mongodb
docker rm -f cuckoo-postgres
docker rm -f cuckoo-es
docker rm -f cuckoo

docker run -dit --name cuckoo-mongodb \
  --restart always \
  -v cuckoo-mongodb-data:/data/db \
  -e MONGO_INITDB_ROOT_USERNAME=root \
  -e MONGO_INITDB_ROOT_PASSWORD=wViWwYOUsmRbd0KAMU \
  -e MONGO_INITDB_DATABASE=admin \
  -v $PWD/mongodb/:/docker-entrypoint-initdb.d/ \
  mongo:5

docker volume create cuckoo-postgres-data

docker run -dit --name cuckoo-postgres \
  -v cuckoo-postgres-data:/var/lib/postgresql/data/pgdata \
  -e PGDATA=/var/lib/postgresql/data/pgdata \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=RSSEyXDZzLTLd4XgvD \
  postgres:15

docker volume create cuckoo-es-data

docker run -dit --name cuckoo-es \
  -e "discovery.type=single-node" \
  elasticsearch:7.17.10

docker run -dit --name cuckoo \
  --link cuckoo-postgres \
  --link cuckoo-mongodb \
  --link cuckoo-es \
  -w /home/cuckoo/ \
  -v $PWD/tmp/:/home/cuckoo/ \
  -v $PWD/conf:/home/cuckoo/.cuckoo/conf \
  -p 33888:8000 \
  ilaipi/cuckoo:1.0 \
  8000
