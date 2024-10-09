==========================================
Lab 4: Docker
==========================================

This is the documentation for the CNIT 48101 Lab 4 "Docker" Created by Jacob Bauer & Nick Kuenning


Section 1 (Creating Docker File)
####################################

In this section we created a docker file that creates a LAMP/LEMP Stack within a container. To acomplish this

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


run shell
sudo sh lab4_script.sh
