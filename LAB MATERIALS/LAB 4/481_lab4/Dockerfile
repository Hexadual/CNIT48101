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

#

# Copy web files to the Apache root directory
COPY ./web /var/www/html

# Expose port 80
EXPOSE 80

# Start Apache in the foreground (required in Docker)
CMD ["apachectl", "-D", "FOREGROUND"]








###
#FROM ubuntu:22.04

# gets rid of timezone prompt
#ENV DEBIAN_FRONTEND=noninteractive

#RUN executes at build time
#Installing LAMP stack (apache, mysql, php)
#RUN apt-get update && apt-get install -y \
#    software-properties-common \
#    && add-apt-repository ppa:ondrej/php \
#    && apt-get update 

#RUN apt-get update && apt-get install -y \
#    nginx \
#    php7.3 \
#    php7.3-fpm \
#    php-cli \
#    php-mysql \
#    mysql-server \
#    && rm -rf /var/lib/apt/lists/*

#Set environment variables (apache log directory)
#ENV NGINX_LOG_DIR=/var/log/nginx

#Copy a local web directory into container to be served
#COPY ./web /var/www/html

#Expose port 80
#EXPOSE 80

#Start services (CMD executes at run time)
#RUN service nginx start && service php7.3-fpm start && tail -f /dev/null