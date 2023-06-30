#!/bin/sh

networkName="cuckoo-network"
cuckooImageName="ilaipi/cuckoo"
cuckooImageTag="1.0"

mongoContainerName="cuckoo-mongodb"
pgContainerName="cuckoo-postgres"
esContainerName="cuckoo-es"
cuckooContainerName="cuckoo"

mongoVolumeName="cuckoo-mongodb-data"
pgVolumeName="cuckoo-postgres-data"
esVolumeName="cuckoo-es-data"

docker build -t $cuckooImageName:$cuckooImageTag .

docker network create $networkName

docker rm -f $mongoContainerName
docker rm -f $pgContainerName
docker rm -f $esContainerName
docker rm -f $cuckooContainerName

docker volume create $mongoVolumeName

docker run -dit --name $mongoContainerName \
  --restart always \
  --network $networkName \
  -v $mongoVolumeName:/data/db \
  -e MONGO_INITDB_ROOT_USERNAME=root \
  -e MONGO_INITDB_ROOT_PASSWORD=wViWwYOUsmRbd0KAMU \
  -e MONGO_INITDB_DATABASE=admin \
  -v $PWD/mongodb/:/docker-entrypoint-initdb.d/ \
  mongo:5

docker volume create $pgVolumeName

docker run -dit --name $pgContainerName \
  --network $networkName \
  -v $pgVolumeName:/var/lib/postgresql/data/pgdata \
  -e PGDATA=/var/lib/postgresql/data/pgdata \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=RSSEyXDZzLTLd4XgvD \
  postgres:15

docker volume create $esVolumeName

docker run -dit --name $esContainerName \
  --network $networkName \
  -v $esVolumeName:/usr/share/elasticsearch/data \
  -e "discovery.type=single-node" \
  elasticsearch:7.17.10

# cuckoo 容器: 
# 8000 端口是 cuckoo web 的端口
# 2042 端口是 result server 的端口
# 5900 端口是 qemu 启动虚拟机时， vnc server 的端口。实际可能不需要访问

docker run -dit --name $cuckooContainerName \
  --network $networkName \
  --device=/dev/kvm \
  --privileged \
  -e DISPLAY=${DISPLAY} \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -w /home/cuckoo/ \
  -v $PWD/tmp/:/home/cuckoo/ \
  -v $PWD/conf:/home/cuckoo/.cuckoo/conf \
  -p 32768:8000 \
  -p 32771:2042 \
  -p 32772:5900 \
  $cuckooImageName:$cuckooImageTag \
  8000
