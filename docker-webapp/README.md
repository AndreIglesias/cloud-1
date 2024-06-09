# Docker Compose Configuration for WordPress Deployment

This repository contains Docker configurations for deploying a WordPress site with Nginx, MariaDB, and PhpMyAdmin, along with a Cloudflare tunnel for secure access.

## Overview

This setup includes the following services:
- **Nginx**: Serves as the web server.
- **WordPress**: The content management system.
- **PhpMyAdmin**: Provides a web interface for MariaDB.
- **MariaDB**: The database server.
- **Cloudflare Tunnel**: Secures access to your services.

### Cloudflare Tunnel

Cloudflare Tunnel provides a secure way to expose your services to the internet without needing to open ports on your firewall or router. It uses Cloudflare's network to provide secure, fast, and reliable access to your services.

## Prerequisites

- Docker: [Install Docker](https://docs.docker.com/get-docker/)
- Docker Compose: [Install Docker Compose](https://docs.docker.com/compose/install/)

## Configuration

### Networks

All services are connected via a custom Docker network named `inception-network`.

```yaml
networks:
  inception-network:
    name: inception-network
```

### Volumes

Docker volumes are used for persistent storage of WordPress and MariaDB data.

```yaml
volumes:
  wordpress_data:
  mariadb_data:
```

### Services

#### Nginx

Nginx acts as the web server for the WordPress site.

```yaml
nginx:
  image: nginx
  container_name: nginx
  build:
    context: requirements/nginx
    dockerfile: Dockerfile
  ports:
    - "443:443"
  restart: always
  networks:
    - inception-network
  volumes:
    - wordpress_data:/var/www/html
  depends_on:
    - wordpress
    - phpmyadmin
```

#### WordPress

The main WordPress service.

```yaml
wordpress:
  image: wordpress
  container_name: wordpress
  build:
    context: requirements/wordpress
    dockerfile: Dockerfile
  env_file: .env
  restart: always
  networks:
    - inception-network
  depends_on:
    - mariadb
  volumes:
    - wordpress_data:/var/www/html
```

#### PhpMyAdmin

Provides a web interface to manage the MariaDB database.

```yaml
phpmyadmin:
  image: phpmyadmin
  container_name: phpmyadmin
  restart: always
  environment:
    PMA_HOST: mariadb
    MYSQL_ROOT_PASSWORD: ${DB_ROOT_PWD}
  networks:
    - inception-network
  depends_on:
    - mariadb
```

#### MariaDB

The database server for WordPress.

```yaml
mariadb:
  image: mariadb
  container_name: mariadb
  build:
    context: requirements/mariadb
    dockerfile: Dockerfile
  env_file: .env
  restart: always
  networks:
    - inception-network
  volumes:
    - mariadb_data:/var/lib/mysql
```

#### Cloudflare Tunnel

Secures access to your services using a Cloudflare tunnel.

```yaml
cloudflared:
  image: cloudflare/cloudflared:latest
  container_name: cloudflared
  command: tunnel --no-autoupdate run --token ${CF_TOKEN}
  restart: always
  networks:
    - inception-network
  env_file: .env
```

## Environment Variables

Create a `.env` file in the root directory of the repository with the following variables:

```env
DOMAIN_NAME=your_domain_name
DOMAIN_PMA=your_phpmyadmin_domain

# MYSQL Setup
DB_HOST=mariadb
DB_ROOT_PWD=your_mariadb_root_password
DB_ROOT_NAME=your_mariadb_root_name
DB_USER=your_mariadb_user
DB_USER_PWD=your_mariadb_user_password
DB_NAME=wordpress

# WordPress Setup
WP_ADMIN=your_wordpress_admin_username
WP_ADMIN_PWD=your_wordpress_admin_password
WP_ADMIN_MAIL=your_wordpress_admin_email
WP_USER=your_wordpress_user_username
WP_USER_PWD=your_wordpress_user_password
WP_USER_MAIL=your_wordpress_user_email

# Cloudflare Token
CF_TOKEN=your_cloudflare_token
```

## Setup and Usage

### Step 1: Create Environment File

Create a `.env` file in the root directory of the repository with the appropriate values as shown above.

### Step 2: Build and Start the Services

Use Docker Compose to build and start the services:

```sh
make
```

This command will build the Docker images and start the containers in detached mode.

### Step 3: Access Your Services

- **WordPress**: Accessible at `https://${DOMAIN_NAME}`
- **PhpMyAdmin**: Accessible at `https://${DOMAIN_PMA}`
- **MariaDB**: Managed via PhpMyAdmin
- **Cloudflare Tunnel**: Manages secure access to your services

### Step 4: Stopping and Removing Services

To stop and remove the containers, use:

```sh
make rm
```

## Notes

- Ensure Docker and Docker Compose are correctly installed and configured on your machine.
- Modify the configuration files as needed to fit your specific environment and requirements.
- Use appropriate environment variable values in the `.env` file for security and functionality.
