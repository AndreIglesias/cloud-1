#!/usr/bin/env bash

mkdir -p /var/www/html /var/run/php/

if [ ! -e /var/www/html/wordpress ]; then

	# Download Wordpress
	echo "Downloading Wordpress..."
	wget -O /tmp/latest.tar.gz --no-check-certificate https://wordpress.org/latest.tar.gz;
	tar -xvzf /tmp/latest.tar.gz -C /var/www/html/;

	# Configuring Wordpress
	cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php
	
	# Replace the default values with the environment variables
	sed -i "s/database_name_here/$DB_NAME/g" /var/www/html/wordpress/wp-config.php
	sed -i "s/username_here/$DB_USER/g" /var/www/html/wordpress/wp-config.php
	sed -i "s/password_here/$DB_USER_PWD/g" /var/www/html/wordpress/wp-config.php
	sed -i "s/localhost/$DB_HOST/g" /var/www/html/wordpress/wp-config.php

	echo "Installing Wordpress..."
	wp-cli core install --url=$DOMAIN_NAME --title=Inception --admin_user=$WP_ADMIN --admin_password=$WP_ADMIN_PWD --admin_email="$WP_ADMIN_MAIL" --allow-root --path=/var/www/html/wordpress
	echo "Creating user..."
	wp-cli user create $WP_USER $WP_USER_MAIL --role=editor --user_pass="$WP_USER_PWD" --allow-root --path=/var/www/html/wordpress
fi

echo "Starting php-fpm..."
php-fpm7.4 --nodaemonize
