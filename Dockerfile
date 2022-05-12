FROM nimmis/apache:14.04

MAINTAINER nimmis <kjell.havneskold@gmail.com>

# disable interactive functions
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y git openssh-client libmysqlclient-dev

RUN apt-get install -y php5 libapache2-mod-php5 php5-fpm php5-cli php5-mysqlnd php5-pgsql php5-sqlite php5-redis php5-apcu php5-intl php5-imagick php5-mcrypt php5-json php5-gd php5-curl php5-imap php5-ldap php5-xmlrpc php5-xsl
RUN php5enmod mcrypt
RUN rm -rf /var/lib/apt/lists/* && cd /tmp && curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer
RUN sed -i 's/display_errors = On/display_errors = Off/g' /etc/php5/apache2/php.ini
RUN sed -i 's/short_open_tag = Off/short_open_tag = On/g' /etc/php5/apache2/php.ini
RUN a2enmod rewrite
# Configure apache
RUN sed -i 's/\(^upload_max_filesize = \).*/\120M/g' /etc/php5/apache2/php.ini
RUN sed -i 's/AllowOverride None/AllowOverride All/g' /etc/apache2/apache2.conf
RUN service apache2 restart
