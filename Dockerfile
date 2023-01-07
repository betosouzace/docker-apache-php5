FROM nimmis/apache:14.04

# disable interactive functions
ENV DEBIAN_FRONTEND noninteractive

# Install git and openssh-client
RUN apt-get update && apt-get install -y git openssh-client

# Install MySQL client libraries
RUN apt-get install -y libmysqlclient-dev

# Install PHP and various PHP extensions
RUN apt-get install -y php5 libapache2-mod-php5
RUN apt-get install -y php5-fpm php5-cli php5-mysqlnd php5-pgsql php5-sqlite php5-redis
RUN apt-get install -y php5-apcu php5-intl php5-imagick
RUN apt-get install -y php5-mcrypt php5-json php5-gd php5-curl
RUN apt-get install -y php5-imap php5-ldap php5-xmlrpc php5-xsl

# Enable the mcrypt PHP extension
RUN php5enmod mcrypt

# Install Composer
RUN rm -rf /var/lib/apt/lists/* && cd /tmp && curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

# Configure PHP settings in /etc/php5/apache2/php.ini
RUN sed -i 's/display_errors = On/display_errors = Off/g' /etc/php5/apache2/php.ini
RUN sed -i 's/short_open_tag = Off/short_open_tag = On/g' /etc/php5/apache2/php.ini

# Enable the Apache rewrite module
RUN a2enmod rewrite

# Configure Apache in /etc/apache2/apache2.conf
RUN sed -i 's/\(^upload_max_filesize = \).*/\120M/g' /etc/php5/apache2/php.ini
RUN sed -i 's/AllowOverride None/AllowOverride All/g' /etc/apache2/apache2.conf

# Set the working directory to /var/www/html
WORKDIR /var/www/html

# Expose port 80 from the container
EXPOSE 80

# Start Apache automatically when the container is started
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
