#!/bin/sh
USER=$1

if [ -z $USER ]; then
   echo "$0 username"
   exit
fi

if id $USER > /dev/null 2>&1; then 
   echo "$USER exist"
   exit
fi

mkdir -p /home/$USER
useradd $USER -d /home/$USER -s /bin/bash

cd /home/$USER
mkdir .ssh
touch .ssh/authorized_keys

chmod 700 .ssh
chmod 600 .ssh/authorized_keys
chown -R $USER:$USER /home/$USER

echo "done, please update public key for $USER"

