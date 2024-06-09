FROM debian:bullseye

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
	nginx openssl php-fpm && \
	apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/nginx/ssl && \
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt \
	-subj "/C=FR/ST=Paris/L=Paris/O=42/OU=42/CN=ciglesia.42.fr"

COPY conf/nginx.conf /etc/nginx/conf.d/default.conf

RUN mkdir -p /run/php /var/www/html && php-fpm7.4

CMD ["nginx", "-g", "daemon off;"]