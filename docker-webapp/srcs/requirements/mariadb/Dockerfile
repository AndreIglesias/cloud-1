FROM debian:bullseye

ENV DEBIAN_FRONTEND=noninteractive

# Update and install MariaDB
RUN apt-get update && apt-get install -y mariadb-server && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

# Copy MariaDB configuration file
COPY conf/my.cnf /etc/mysql/mariadb.conf.d/
COPY tools/db_init.sh /tmp/

RUN chmod +x /tmp/db_init.sh

# Start MariaDB service
CMD ["/tmp/db_init.sh"]
