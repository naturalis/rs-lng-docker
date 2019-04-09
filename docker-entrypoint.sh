#!/bin/bash

# Checkout RS 
if ! [[ -d /var/www/html/resourcespace/.svn ]] ; then
	# Delete source dir, so shared directories can be installed
	rm -rf /var/www/html/resourcespace; 
	mkdir -p /var/www/html/resourcespace; 
	cd /var/www/html/resourcespace; 
	svn co https://svn.resourcespace.com/svn/rs/releases/8.6 . ;
fi

# Plugins are in git repo; use svn to clone repo (no need to install git)
if ! [[ -d /var/www/resourcespace_lng_api.git/.svn ]] ; then
	cd /var/www; 
	rm -rf /var/www/resourcespace_lng_api.git; 
	svn co --depth empty https://github.com/naturalis/resourcespace_lng_api.git; 
	cd resourcespace_lng_api.git; 
	svn up trunk; 
	ln -s /var/www/resourcespace_lng_api.git/trunk/plugins/api_new_user_lng \
		/var/www/html/resourcespace/plugins/api_new_user_lng; 
	ln -s /var/www/resourcespace_lng_api.git/trunk/plugins/api_upload_lng \
		/var/www/html/resourcespace/plugins/api_upload_lng;
fi

/usr/sbin/apache2ctl -D FOREGROUND