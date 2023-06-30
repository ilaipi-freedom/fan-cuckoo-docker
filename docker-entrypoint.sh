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

sudo chmod -R 777 /home/cuckoo/.cuckoo

cuckoo -d || true

sudo brctl addbr cuckoo-bridge
sudo ip tuntap add name tap0 mode tap
sudo ip link set dev tap0 up
sudo brctl addif cuckoo-bridge tap0
sudo ip addr add 192.168.1.1/24 dev cuckoo-bridge
sudo ip link set dev cuckoo-bridge up

# cuckoo community

# Start cuckoo web server
cuckoo web runserver 0.0.0.0:"$@"
