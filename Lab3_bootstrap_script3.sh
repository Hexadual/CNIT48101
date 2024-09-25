#!/bin/bash

#install httrack
echo "Installing httrack..."
sudo apt-get install -y httrack

#Fetch web pages from master node
echo "Fetching web pages from master node..."
httrack http://192.168.56.50 -O /home/vagrant/website_copy

echo "Files copied to /home/vagrant/website_copy"
