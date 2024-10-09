==========================================
Lab 4: Docker
==========================================

This is the documentation for the CNIT 48101 Lab 4 "Docker" Created by Jacob Bauer & Nick Kuenning


Section 1 (Creating Docker File)
####################################

In this section we created a docker file that creates a LAMP/LEMP Stack within a container. To acomplish this we used a base image of Ubuntu 22.04 as seen in the dockerfile below in the FROM line. To get rid of user interaction when running this container we add the noninteractive line. Next we install all the necessary dependencies required to run a LAMP stack including Apache2, php, and mysql. We then enable the apache module to work with php and copy the .web directory into the container that include the index.html and phpinfo.php files to be served on the apache webpage.  

DOCKER FILE

.. code-block:: Docker

    FROM ubuntu:22.04

    # Gets rid of timezone prompt
    ENV DEBIAN_FRONTEND=noninteractive

    # Install Apache, PHP, and necessary extensions
    RUN apt-get update && apt-get install -y \
        apache2 \
        mysql-server \
        php \
        libapache2-mod-php \ 
        php-mysql \
        php-cli \
        php-zip \
        php-json \
        php-curl \
        php-xml \
        php-mbstring \
        && apt-get clean
    # Enable Apache's mod_php module
    RUN a2enmod php8.1 && a2enmod rewrite

    # Copy web files to the Apache root directory
    COPY ./web /var/www/html

    # Expose port 80
    EXPOSE 80

    # Start Apache in the foreground (required in Docker)
    CMD ["apachectl", "-D", "FOREGROUND"]

Below are the files included in the /web directory that is copied into the container upon building. It includes two files, index.html and phpinfo.php. The index.html file is used to edit the homepage being served by apache to title it as our lab4 webpage. The phpinfo.ph is used to show information about the php being used for the LAMP container.
INDEX.html File
.. code-block:: html
    
    <!DOCTYPE html>
    <html lnag=""en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0"
        <title> CNIT48101 Lab 4 Docker Containers </title>
    </head>
    <body>
        <h1> This is our LAMP stack docker container! </h1>
    </body>
    </html>
    
PHP FILE

.. code-block:: php

    <?php
    foreach (get_loaded_extensions() as $i => $ext) {
        echo $ext .' => '. phpversion($ext). '<br/>';
    }
    phpinfo(INFO_GENERAL);
    ?>

The last file used in this lab is a shell script that pulls the docker container from dockerhub and runs it on the desired machine. This scrip can be run by typing `sudo sh lab4_script.sh`

SHELL File
.. code-block:: bash

    #!/bin/bash

    # Pull and run container from dockerhub
    docker pull nick637/lab4:latest
    docker run nick637/lab4:latest

