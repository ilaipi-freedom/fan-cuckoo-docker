#!/bin/sh

# Check if __init__.py file does not exist
if [ ! -f "/home/cuckoo/.cuckoo/__init__.py" ]; then
    cuckoo -d || true
fi

# Start cuckoo web server
cuckoo web runserver 0.0.0.0:"$@"
