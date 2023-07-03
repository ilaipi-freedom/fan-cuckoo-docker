#!/bin/sh

bridge_name="br0"
host_interface_name="ens160"

# 检查桥接设备是否已存在
if ! ip link show "$bridge_name" &> /dev/null; then

  # 创建虚拟网络桥接
  sudo brctl addbr "$bridge_name"
  sudo brctl addif "$bridge_name" "$host_interface_name"
  sudo ip link set dev "$bridge_name" up
  sudo ip addr add 192.168.1.1/24 dev "$bridge_name"

  # 配置网络转发
  sudo sysctl net.ipv4.ip_forward=1
  sudo iptables -A FORWARD -i $host_interface_name -o $bridge_name -s 192.168.1.0/24 -j ACCEPT
  sudo iptables -A FORWARD -i $bridge_name -o $host_interface_name -d 192.168.1.0/24 -j ACCEPT
  sudo iptables -t nat -A POSTROUTING -o $host_interface_name -j MASQUERADE
else
  echo "The bridge device '$bridge_name' already exists."
fi


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

if ! docker network inspect $networkName >/dev/null 2>&1; then
    docker network create $networkName
    echo "INFO: Docker Network $networkName created successfully"
else
    echo "INFO: Docker Network $networkName already exists"
fi

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
