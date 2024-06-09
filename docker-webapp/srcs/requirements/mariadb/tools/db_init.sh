#!/usr/bin/env bash

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

if [ ! -d "/var/lib/mysql/mysql" ]; then
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

cat << EOF > /tmp/init.sql
CREATE DATABASE $DB_NAME;
GRANT all privileges on $DB_NAME.* to '$DB_USER'@'%' identified by '$DB_USER_PWD';
GRANT all privileges on *.* to '$DB_ROOT_NAME'@'%' identified by '$DB_ROOT_PWD';
USE $DB_NAME;
FLUSH PRIVILEGES;
EOF

/usr/bin/mysqld_safe --datadir='/var/lib/mysql' --init-file=/tmp/init.sql
