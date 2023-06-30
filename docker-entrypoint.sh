#!/bin/sh

if [ ! -d "/home/cuckoo/.cuckoo/log" ]; then
    mkdir -p /home/cuckoo/.cuckoo/log
fi

if [ ! -d "/home/cuckoo/.cuckoo/yara" ]; then
    mkdir -p /home/cuckoo/.cuckoo/yara
fi

if [ ! -f "/home/cuckoo/.cuckoo/.cwd" ]; then
    touch /home/cuckoo/.cuckoo/.cwd
fi

cuckoo -d || true

sudo brctl addbr vboxnet0 && \
  ip addr add 192.168.1.100/24 dev vboxnet0 && \
  ip link set vboxnet0 up && \
  ip link add eth0 type veth peer name eth0peer && \
  brctl addif vboxnet0 eth0peer && \
  ip link set eth0peer up

cuckoo community

# Start cuckoo web server
cuckoo web runserver 0.0.0.0:"$@"
