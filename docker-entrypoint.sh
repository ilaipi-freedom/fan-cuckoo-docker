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

# cuckoo community

# Start cuckoo web server
cuckoo web runserver 0.0.0.0:"$@"
