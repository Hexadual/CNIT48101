#!/bin/bash

#Install Webserver
echo "installing NGINX"
sudo apt-get install -y nginx

#Create Index HTML file
sudo tee /var/www/html/index.html > /dev/null <<EOF
<html>
    <head><title> Master - Index </title></head>
     <body><h1>This is the index.html file on the master VM</h1></body>
</html>
EOF

#Second HTML file
sudo tee /var/www/html/second.html > /dev/null <<EOF
<html>
  <head><title>Master - Second</title></head>
  <body><h1>This is the second.html file on the master VM</h1></body>
</html>
EOF

#Restart service
sudo systemctl restart nginx
