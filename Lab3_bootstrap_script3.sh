#!/bin/bash

#install httrack
echo "Installing httrack..."
sudo apt-get install -y httrack

#Fetch web pages from master node
echo "Fetching web pages from master node..."
httrack http://192.168.50.50 -O ~/website_copy

echo "Files copied to ~/website_copy"
