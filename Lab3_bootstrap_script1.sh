#!/bin/bash

#Update hosts file
echo "Updating /etc/hosts..."
cat <<EOF | sudo tee -a /etc/hosts
192.168.50.50 master
192.168.50.51 worker1
192.168.50.52 worker2
EOF

#Update system
sudo apt-get update -y
sudo apt-get upgrade -y
