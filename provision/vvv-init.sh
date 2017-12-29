#!/usr/bin/env bash

# Make a database, if we don't already have one
echo -e "\nCreating database '${VVV_SITE_NAME}' (if it's not already there)"
mysql -u root --password=root -e "CREATE DATABASE IF NOT EXISTS workshopdigital"
mysql -u root --password=root -e "GRANT ALL PRIVILEGES ON workshopdigital.* TO wp@localhost IDENTIFIED BY 'wp';"
echo -e "\n DB operations done.\n\n"

# Nginx Logs
mkdir -p ${VVV_PATH_TO_SITE}/log
touch ${VVV_PATH_TO_SITE}/log/error.log
touch ${VVV_PATH_TO_SITE}/log/access.log

# Install and configure the latest stable version of WordPress
mkdir -p ${VVV_PATH_TO_SITE}/public_html
cd ${VVV_PATH_TO_SITE}/public_html
if ! $(wp core is-installed --allow-root); then
  wp core download --path="${VVV_PATH_TO_SITE}/public_html" --allow-root
  wp core config --dbname="workshopdigital" --dbuser=wp --dbpass=wp --quiet --allow-root
  wp core install --url="${VVV_SITE_NAME}.test" --quiet --title="${VVV_SITE_NAME}" --admin_name=admin --admin_email="admin@${VVV_SITE_NAME}.test" --admin_password="password" --allow-root
else
  wp core update --allow-root
fi