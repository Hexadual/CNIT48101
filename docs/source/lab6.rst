==========================================
Lab 4: Openstack
==========================================

This is the documentation for the CNIT 48101 Lab 6 "Openstack" Created by Jacob Bauer & Nick Kuenning


Section 1 (Setting up DevStack (OpenStack))
###############################################

To Set up DevStack, we first created a local.conf file in the devstack directory. This file contained the configuration for the OpenStack installation. We then ran the `stack.sh` script to install OpenStack. After the installation was complete, we were able to access the OpenStack dashboard by navigating to the IP address of the DevStack machine in a web browser.

This is the lcoal.conf file that we used that allowd us to install OpenStack.
.. code-block:: conf
    
    [[local|localrc]]
    ADMIN_PASSWORD=secret
    DATABASE_PASSWORD=$ADMIN_PASSWORD
    RABBIT_PASSWORD=$ADMIN_PASSWORD
    SERVICE_PASSWORD=$ADMIN_PASSWORD

Section 2 (Creating a server template)
########################################

To create a server template, we first logged into the OpenStack dashboard and navigated to the "Compute" section. We then clicked on "Images" and selected the "Create Image" option. We provided the necessary information, such as the image name and the image source, and clicked on "Create Image". For out image source, we used the ubuntu bionic image from the vagran lab. 

Section 3 (Deploying a server instance)
########################################

After we created an image we then needed to deploy a server with that image. To do that we clicked the "Launch Instance" button in the OpenStack dashboard. We provided the necessary information, such as the instance name, flavor, and image, and clicked on "Launch". The server instance was then created and we were able to access it through the OpenStack dashboard.

These are the screenshots of the OpenStack dashboard that show the process of creating a server template and deploying a server instance.

.. image:: /CNIT48101/LAB MATERIALS/Lab 6/2.png
    :alt: Details Panel


.. image:: /CNIT48101/LAB MATERIALS/Lab 6/3.png
    :alt: Source Panel


.. figure:: /CNIT48101/LAB MATERIALS/Lab 6/4.png
    :alt: Flavor Panel


.. figure:: /LAB MATERIALS/Lab 6/5.png
    :alt: Network Panel

