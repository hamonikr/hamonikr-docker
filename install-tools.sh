#!/bin/sh
set -e
dir=`dirname "$0"`
cd "$dir"

set -x

cp tools/docker-ssh /usr/local/bin/
chmod +x /usr/local/bin/docker-ssh
mkdir -p /usr/local/share/hamonikr-docker
cp image/services/sshd/keys/insecure_key /usr/local/share/hamonikr-docker/
chmod 644 /usr/local/share/hamonikr-docker/insecure_key
