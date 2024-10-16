
==========================================
Lab 5: Docker Compose WordPress
==========================================

This is the documentation for the CNIT 48101 Lab 5 "Docker Compose" part 2 "WordPress exercise" Created by Jacob Bauer & Nick Kuenning


Section 1 (Creating Docker compose File)
####################################
For this section we were given a docker compose file from `The Wordpress Github page <https://github.com/docker/awesome-compose/blob/master/official-documentation-samples/wordpress/README.md>`_ This quockstart guide was used to create a wordpress site with a MySQL database. 

The docker compose file examplew was 

.. code-block:: Docker

        services:
    db:
        # We use a mariadb image which supports both amd64 & arm64 architecture
        image: mariadb:10.6.4-focal
        # If you really want to use MySQL, uncomment the following line
        #image: mysql:8.0.27
        command: '--default-authentication-plugin=mysql_native_password'
        volumes:
        - db_data:/var/lib/mysql
        restart: always
        environment:
        - MYSQL_ROOT_PASSWORD=somewordpress
        - MYSQL_DATABASE=wordpress
        - MYSQL_USER=wordpress
        - MYSQL_PASSWORD=wordpress
        expose:
        - 3306
        - 33060
    wordpress:
        image: wordpress:latest
        volumes:
        - wp_data:/var/www/html
        ports:
        - 80:80
        restart: always
        environment:
        - WORDPRESS_DB_HOST=db
        - WORDPRESS_DB_USER=wordpress
        - WORDPRESS_DB_PASSWORD=wordpress
        - WORDPRESS_DB_NAME=wordpress
    volumes:
    db_data:
    wp_data:


This docker compose file was all that was required for us to be able to host a wordpress site. All required files and dependies were automaticlty installed when we ran the command `docker-compose up -d` in the directory where the docker compose file was located.