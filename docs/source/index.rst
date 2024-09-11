==========================================
CNIT 48101 Cloud Computing documentation
==========================================

This is the documentation for the CNIT 48101 Lab 2 "cloud-init, VirtualBox and vagrant" Created by Jacob Bauer & 

.. contents:: Table of Contents
   :depth: 1
   :local:
   :backlinks: none



===
Section 1 (Hardware Information)
===

To gather the hardware information of the system, we this section to our cloud-init file.

.. code-block:: yaml
   runcmd:
   - /usr/bin/lshw > /home/admin1/lshw.txt

---

===
Section 2 (OS install)
===
Install process: OS Info and installation method

===
Section 3 (Network Configuration)
===
For the network configuration, we chose to leave the network unconfigured and allow the machine to get an IP address from the CIT DHCP server.

---

===
Section 4 (SSH configuration)
===
For the SSH configuration, we added an SSH key into the cloud-init file to allow us to SSH into the machine wihtiou the need for a password.

To acomplish this we added the following to our cloud-init file.

```
   users: 
   - name: admin1
   sudo: ALL=(ALL) NOPASSWD:ALL
   groups: users, admin
   home: home/admin1
   ssh_authorized_keys: 
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCN16qjaXPU8mYKkGAg4qEWuMqwe9Ax0HGayd7dKIAoVXSe2cFlzsxp1LtAi6m7wrW0uybsf9nLz82sM95ofAZEyCotc/695cQ8QfvTYGmSNRq1dslz7i4ooOXiH0DOL58sTxonRDloy431t0lQWOxwmqhHYEcWsaA+W1P1HxfRR7/OChpNuc6muhrfctn2AVmY7noJRqutrXxUyNg/9orJAAyNUu6gu09amMVOpV/3QGHEQaDjXWPEo0D7b844epZMsDNs6u9w4KWIMJunP4tH9eBnka0Gj8E+YKJftt1zMfpkLUfzXiuWjks9l7PbtLHOS8jVue3sbAjbma72JeJZ
```

===
Section 5 (Cloud-init)
===


After all of the requitemnts were met. All of the different requitemnts were added to our `lab2.yaml` file.

.. code-block:: yaml
   #cloud-config
   # This is the cloud 

   # Update system
   package_update: true
   package_upgrade: true

   # Configure time zone
   timezone: 'US/East'

   #Add hostname
   hostname: lab2

   # Creates admin1 user
   users: 
   - name: admin1
      sudo: ALL=(ALL) NOPASSWD:ALL
      groups: users, admin
      home: home/admin1
      ssh_authorized_keys: 
         - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCN16qjaXPU8mYKkGAg4qEWuMqwe9Ax0HGayd7dKIAoVXSe2cFlzsxp1LtAi6m7wrW0uybsf9nLz82sM95ofAZEyCotc/695cQ8QfvTYGmSNRq1dslz7i4ooOXiH0DOL58sTxonRDloy431t0lQWOxwmqhHYEcWsaA+W1P1HxfRR7/OChpNuc6muhrfctn2AVmY7noJRqutrXxUyNg/9orJAAyNUu6gu09amMVOpV/3QGHEQaDjXWPEo0D7b844epZMsDNs6u9w4KWIMJunP4tH9eBnka0Gj8E+YKJftt1zMfpkLUfzXiuWjks9l7PbtLHOS8jVue3sbAjbma72JeJZ
   
   #Install packages
   packages:
   - cowsay
   - sl	

   #Run commands
   runcmd:
   - /usr/bin/lshw > /home/admin1/lshw.txt
   - echo "Hello from our group!"
   - cowsay Hello from our group! 
