FROM php:7.2-apache

# Install required php modules
RUN set -ex; \
	\
	if command -v a2enmod; then \
		a2enmod rewrite; \
	fi; \
	\
	apt-get update; \
	apt-get install -y --no-install-recommends \
		subversion \
		imagemagick \
		ghostscript \
		antiword \
		xpdf \
		ffmpeg \
		libimage-exiftool-perl \
		libjpeg-dev \
		libgif-dev \
		libpng-dev; \
	\
	docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr; \
	\
	docker-php-ext-install \
		mysqli \
		zip \
		gd; \
	\
	docker-php-ext-enable \
		mysqli \
		zip \
		gd; \
	\
	cd /usr/local/etc/php && ln -s php.ini-production php.ini; \
    { \
        echo 'post_max_size = 100M'; \
        echo 'upload_max_filesize = 100M'; \
        echo 'memory_limit = 200M'; \
        echo 'max_execution_time = 1000'; \
	} > /usr/local/etc/php/conf.d/zzz_custom.ini;

ADD config/apache-config.conf /etc/apache2/sites-enabled/000-default.conf
ADD docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]