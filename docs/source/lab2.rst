==========================================
Lab 2: cloud-init
==========================================

This is the documentation for the CNIT 48101 Lab 2 "cloud-init, VirtualBox and vagrant" Created by Jacob Bauer & Nick Kuenning

.. contents:: Table of Contents
   :depth: 1
   :local:
   :backlinks: none

Section 1 (Hardware Information)
####################################

To gather the hardware information of the system, we added this section to our cloud-init file.

.. code-block:: yaml

   runcmd:
   - /usr/bin/lshw > /home/admin1/lshw.txt

What this command dose is it runs the `lshw` command and saves the output to a file called `lshw.txt` in the home directory of the `admin1` user.

This tool comes installed by default on Ubuntu and therefor there was no need to install any additional packages.

Section 2 (OS install)
####################################
For the OS install, we chose to use the Ubuntu 20.04 LTS image. We chose this image because it is a long term support release and is widely used. We also chose this image because it is a lightweight image and is easy to use.


Section 3 (Network Configuration)
####################################
For the network configuration, we chose to leave the network unconfigured and allow the machine to get an IP address from the CIT DHCP server.

Section 4 (SSH configuration)
####################################
For the SSH configuration, we added an SSH key into the cloud-init file to allow us to SSH into the machine wihtiou the need for a password.

To acomplish this we added the following to our cloud-init file.

.. code-block:: yaml

   #Creates admin1 user
   users: 
     - name: admin1 # Name of the user
   sudo: ALL=(ALL) NOPASSWD:ALL # maks it so that no password is required for sudo for all users
   groups: users, admin # adds admin1 to these groups
   home: home/admin1 # sets the home directory for admin1
   passwd: Group99Admin # sets the password for admin1
   ssh_authorized_keys:  # adds the ssh key to the authorized keys file
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDCR40r6+tjs0Jkbj7ykzJPWZPa26v7wiQI6txejvCLAY4uyKGDo+uCQDeZL66R99oyWIctU8Ubn4vbHLA5ThhNIlQ/BFqiP+hOpU9LFVPLxLiPw+x78vmXavShz0S8FJIUBHQSkS2yczH+wAug7SmdYuvm6bLUyMYuTpI4DWmII9vg2451uLfHBGvMk2hHmF+Vglc346dBYMHuOSFWn1gtvhOAP/4d9Z+Hzcl8a/JDKryOWlsqeWCUufDAVM6LgpbWIb3h8ph1lpSKaSnZYCzD5WWnSdjGGBkyT1L3yABLWJbFdi9UyGrVu49yHGlLRYZXuC8zKiF/DBnIE4e1xPdUdj3hO0ugnc9+Kymfy2bhPwGHLbphhr+vy0tirDLwvNCxNirM3lP0bXi2zUajZh/TzRR+p2HZ9m4xF3158JKqmC9pNo59M3js0MNb6ng76SvHY0ExTwvbYFE2MIw2xY+DbC6z6PwhrdkKtjHNrnGNpJPCfm8U8sTdaH49nBFzmkKQU0jBC3HZe1TJj+cM3XtFrWiZXzRhjDX/ycVaK5P8E5JOkpc5F1H4JPIpO6JV7ktj9a4EfAmzke6tH9W6JHYVSbPHFp5mxBkj2VpLcJW+06Yx1SK8NxgqGl9QcRtpLZ+oZAn2JupfdkLtuFKx7jxhsG5ulgMqcfE9kse4DXFxPw== hhhh

Section 5 (Cloud-init)
####################################

After all of the requirements were met. All of the different requirements were added to our `lab2.yaml` file which is below.

.. code-block:: yaml

   #cloud-config
   autoinstall:
   version: 1

   # Update system
   package_update: true
   package_upgrade: true

   # Configure time zone
   timezone: 'US/East'

   #Add hostname
   hostname: lab2

   # Creates admin1 user
   users: 
   - name: admin1 # Name of the user
     sudo: ALL=(ALL) NOPASSWD:ALL # maks it so that no password is required for sudo for all users
     groups: users, admin # adds admin1 to these groups
     home: home/admin1 # sets the home directory for admin1
     passwd: Group99Admin # sets the password for admin1
     ssh_authorized_keys: 
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDCR40r6+tjs0Jkbj7ykzJPWZPa26v7wiQI6txejvCLAY4uyKGDo+uCQDeZL66R99oyWIctU8Ubn4vbHLA5ThhNIlQ/BFqiP+hOpU9LFVPLxLiPw+x78vmXavShz0S8FJIUBHQSkS2yczH+wAug7SmdYuvm6bLUyMYuTpI4DWmII9vg2451uLfHBGvMk2hHmF+Vglc346dBYMHuOSFWn1gtvhOAP/4d9Z+Hzcl8a/JDKryOWlsqeWCUufDAVM6LgpbWIb3h8ph1lpSKaSnZYCzD5WWnSdjGGBkyT1L3yABLWJbFdi9UyGrVu49yHGlLRYZXuC8zKiF/DBnIE4e1xPdUdj3hO0ugnc9+Kymfy2bhPwGHLbphhr+vy0tirDLwvNCxNirM3lP0bXi2zUajZh/TzRR+p2HZ9m4xF3158JKqmC9pNo59M3js0MNb6ng76SvHY0ExTwvbYFE2MIw2xY+DbC6z6PwhrdkKtjHNrnGNpJPCfm8U8sTdaH49nBFzmkKQU0jBC3HZe1TJj+cM3XtFrWiZXzRhjDX/ycVaK5P8E5JOkpc5F1H4JPIpO6JV7ktj9a4EfAmzke6tH9W6JHYVSbPHFp5mxBkj2VpLcJW+06Yx1SK8NxgqGl9QcRtpLZ+oZAn2JupfdkLtuFKx7jxhsG5ulgMqcfE9kse4DXFxPw== hhhh

   #Install packages
   packages:
   - cowsay
   - sl
   - git

   #Run commands
   runcmd:
   - /usr/bin/lshw > /home/admin1/lshw.txt
   - /usr/bin/echo "Hello from our group!"
   - /user/games/cowsay Hello from our group! 


