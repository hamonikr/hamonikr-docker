#!/bin/bash
sudo useradd node_exporter -s /sbin/nologin
sudo apt install curl -y
wget https://github.com/prometheus/node_exporter/releases/download/v1.0.1/node_exporter-1.0.1.linux-amd64.tar.gz
tar xvzf node_exporter-1.0.1.linux-amd64.tar.gz
sudo cp node_exporter-1.0.1.linux-amd64/node_exporter /usr/sbin/

sudo mkdir -p /etc/sysconfig
sudo touch /etc/sysconfig/node_exporter 

sudo cat << 'EOF' > /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter

[Service]
User=node_exporter
EnvironmentFile=/etc/sysconfig/node_exporter
ExecStart=/usr/sbin/node_exporter $OPTIONS

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable node_exporter
systemctl start node_exporter

sudo rm -rf node_exporter-1.0.1.linux-amd64*
sleep 1

# curl http://localhost:9100/metrics