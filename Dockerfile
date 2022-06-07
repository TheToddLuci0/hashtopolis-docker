FROM php:8-apache

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get -y install --no-install-recommends apt-utils zip unzip \
    && apt-get -y install git iproute2 procps lsb-release curl \
    && apt-get -y install mariadb-client \
    # && apt-get install -y apache2 libapache2-mod-php php8-mysql php8 php8-gd php8-pear php8-curl curl git \
    # && curl https://archive.hashtopolis.org/server/stable/HEAD | xargs -I {} curl https://archive.hashtopolis.org/server/stable/{}.zip -o hashtopolis.zip \
    && git clone https://github.com/hashtopolis/server.git /var/www/html/ \
    && touch "/usr/local/etc/php/conf.d/custom.ini" \
	# && echo "display_errors = on" >> /usr/local/etc/php/conf.d/custom.ini \
	&& echo "memory_limit = 256m" >> /usr/local/etc/php/conf.d/custom.ini \
	&& echo "upload_max_filesize = 256m" >> /usr/local/etc/php/conf.d/custom.ini \
	&& echo "max_execution_time = 60" >> /usr/local/etc/php/conf.d/custom.ini \
	# && echo "log_errors = On" >> /usr/local/etc/php/conf.d/custom.ini \
	&& echo "error_log = /dev/stderr" >> /usr/local/etc/php/conf.d/custom.ini \
	# Install extensions (optional)
	&& docker-php-ext-install pdo_mysql \
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*  \
    # Link our site config to the devcontainer
    && rm -rf /etc/apache2/sites-enabled \
	&& ln -s /var/www/html/.devcontainer/sites-enabled /etc/apache2/sites-enabled
    
RUN chown -R www-data:www-data /var/www/html/

ENV DEBIAN_FRONTEND=dialog
