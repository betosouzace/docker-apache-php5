FROM nimmis/apache:14.04

# disable interactive functions
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y git openssh-client libmysqlclient-dev

RUN apt-get install -y php5 libapache2-mod-php5 php5-fpm php5-cli php5-mysqlnd php5-pgsql php5-sqlite php5-redis php5-apcu php5-intl php5-imagick php5-mcrypt php5-json php5-gd php5-curl php5-imap php5-ldap php5-xmlrpc php5-xsl
RUN php5enmod mcrypt
RUN rm -rf /var/lib/apt/lists/* && cd /tmp && curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

RUN sed -i 's/display_errors = On/display_errors = Off/g' /etc/php5/apache2/php.ini
RUN sed -i 's/short_open_tag = Off/short_open_tag = On/g' /etc/php5/apache2/php.ini

# Habilita o módulo rewrite do Apache
RUN a2enmod rewrite

RUN sed -i 's/\(^upload_max_filesize = \).*/\120M/g' /etc/php5/apache2/php.ini
RUN sed -i 's/AllowOverride None/AllowOverride All/g' /etc/apache2/apache2.conf

# Configura as variáveis de ambiente para o PHP - Não funcionou
ENV PHP_DISPLAY_ERRORS "Off"
ENV PHP_SHORT_OPEN_TAG "On"

# Configura as variáveis de ambiente para o Apache - Não sei se funcionou
ENV APACHE_UPLOAD_MAX_FILESIZE "120M"
ENV APACHE_ALLOW_OVERRIDE "All"

RUN service apache2 restart

# Copia os arquivos do projeto para o diretório /var/www/html
# COPY . /var/www/html

# Define o diretório /var/www/html como o diretório de trabalho
WORKDIR /var/www/html

# Expõe a porta 80 do container
EXPOSE 80
