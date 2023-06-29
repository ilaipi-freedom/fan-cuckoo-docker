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

# Check if __init__.py file does not exist
if [ ! -f "/home/cuckoo/.cuckoo/__init__.py" ]; then
    cuckoo -d || true
fi

# Start cuckoo web server
cuckoo web runserver 0.0.0.0:"$@"
