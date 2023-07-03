#!/bin/sh

if [ ! -d "/home/cuckoo/.cuckoo/log" ]; then
    sudo mkdir -p /home/cuckoo/.cuckoo/log
fi

if [ ! -d "/home/cuckoo/.cuckoo/yara" ]; then
    sudo mkdir -p /home/cuckoo/.cuckoo/yara
fi

if [ ! -f "/home/cuckoo/.cuckoo/.cwd" ]; then
    sudo touch /home/cuckoo/.cuckoo/.cwd
fi

sudo brctl addbr br0
sudo brctl addif br0 eth0
sudo ip link set dev br0 up
sudo ip addr add 192.168.1.2/24 dev br0
sudo sysctl net.ipv4.ip_forward=1

sudo chmod -R 777 /home/cuckoo/.cuckoo

cuckoo -d || true

# cuckoo community

# Start cuckoo web server
cuckoo web runserver 0.0.0.0:"$@"
