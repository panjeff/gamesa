#!/bin/sh
cd /usr/local/mongodb/bin
./mongod --bind_ip 127.0.0.1 --fork --logpath /var/log/mongod.log --logappend
