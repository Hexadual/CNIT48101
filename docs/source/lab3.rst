==========================================
Lab 3: Vagrant
==========================================

This is the documentation for the CNIT 48101 Lab 3 "Vagrant" Created by Jacob Bauer & Nick Kuenning

.. contents:: Table of Contents
   :depth: 1
   :local:
   :backlinks: none

Section 1 (Installing Vagrant)
####################################

The first step to installing vagrant on to the Ubuntu Desktop was to install virtualbox. This was done by running the command `sudo apt install virtualbox -y`

The next step was to install vagratn using apt. This was done by running the command `sudo apt install vagrant -y`. The instalation can be verified by running the command `vagrant --version`

The next step after installign Vagrant was to create a project directory. This was done by running the command `mkdir ~/vagrant`. In the folder we created a `Vagrantfile` by running the command `vagrant init ubuntu/trusty64`. The `init` command initializes a Vagrant project and also creates a Vagrant configuration file. This file is configurd in Seccion 2.

Section 2 (Creating Vagrantfile)
####################################

A Vagrant file was created to auto provision and configure three seperate VMs (master, worker1, worker2) through VirtualBox. The Vagrant file references a `config.rb` file that contains variables used to provision the VMs. The `config.rb` file specifies the network, IP address, name, CPUs, and memory to be used to provision the VMs. The Vagrant file addtionally configures the VMs upon provisoning by calling bash scripts to be ran on the specified VM. Three bash scripts were created (see Section 3) and ran upon the provisioning of these VMs. 


This is the Vagrant file that was created:

.. code-block:: ruby

   require_relative 'config.rb'

   Vagrant.configure("2") do |config|
     config.vm.box = $vm_config['box']  

     # Define master VM
     config.vm.define $vm_config['master_name'] do |master|
       master.vm.network "private_network", ip: "#{$vm_config['network']}#{$vm_config['network_base']}"
       master.vm.provider "virtualbox" do |vb|
         vb.cpus = $vm_config['cpus']
         vb.memory = $vm_config['memory']
       end
       master.vm.provision $vm_config['provisioners'][0], path: "Lab3_bootstrap_script1.sh"
       master.vm.provision $vm_config['provisioners'][0], path: "Lab3_bootstrap_script2.sh"
     end

   #Worker1 VMs
     config.vm.define $vm_config['worker1_name'] do |worker1|
       worker1.vm.network "private_network", ip: "#{$vm_config['network']}#{$vm_config['network_base1']}"
       worker1.vm.provider "virtualbox" do |vb|
         vb.cpus = $vm_config['cpus']
         vb.memory = $vm_config['memory']
       end
       worker1.vm.provision $vm_config['provisioners'][0], path: "Lab3_bootstrap_script1.sh"
       worker1.vm.provision $vm_config['provisioners'][0], path: "Lab3_bootstrap_script3.sh"
     end

   #Worker 2 VM
    config.vm.define $vm_config['worker2_name'] do |worker2|
       worker2.vm.network "private_network", ip: "#{$vm_config['network']}#{$vm_config['network_base2']}"
       worker2.vm.provider "virtualbox" do |vb|
         vb.cpus = $vm_config['cpus']
         vb.memory = $vm_config['memory']
       end
       worker2.vm.provision $vm_config['provisioners'][0], path: "Lab3_bootstrap_script1.sh"
       worker2.vm.provision $vm_config['provisioners'][0], path: "Lab3_bootstrap_script3.sh"
     end
   end

This is the `config.rb` file that was created:

.. code-block:: ruby
   
   # config.rb
   vm_config = {
   	'cpus' => 2,
   	'memory' => 2048,
   	'box' => 'ubuntu/bionic64',
   	'master_name' => 'master',
   	'worker1_name' => 'worker1',
   	'worker2_name' => 'worker2',
   	'network' => '192.168.56.',
   	'network_base' => 50,
   	'network_base1' => 51,
   	'network_base2' => 52,
   	'provisioners' => ['shell']
   }
   

Seccion 3 (Creating the bootstrap scripts)
########################################################################

The Vagrant file references three seperate bash scripts to be ran upon the provisioning of the VMs. The first (bootstrap.sh) is ran for all three VMs created and adds a entry to the /etc/hosts file to add all three of the machines IPs and hostnames. The second (bootstrap_master.sh) is ran only upon the provisioning of the master node machine and it creates a NGINX webserver along with two .html files to be served on the webpage. The third script (bootstrap_workers.sh) is ran upon the provisioning of the two worker node machines. This script installs httrack and uses it to copy the .html files being served by the master node.

This is the general `bootstrap.sh` script that is run on all three VMs that contains general configuration.

.. code-block:: bash 

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


This is the `bootstrap_master.sh` script that is run on the master node that creates a NGINX webserver and two `.html` files to be served on the webpage.

.. code-block:: bash

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
   

This is the `bootstrap_workers.sh` script that is run on the worker nodes that installs `httrack` and copies the `.html` files from the master node.

.. code-block:: bash

      #!/bin/bash
   
      #install httrack
      echo "Installing httrack..."
      sudo apt-get install -y httrack
      
      #Fetch web pages from master node
      echo "Fetching web pages from master node..."
      httrack http://192.168.56.50 -O /home/vagrant/website_copy
      
      echo "Files copied to /home/vagrant/website_copy"
      
   
