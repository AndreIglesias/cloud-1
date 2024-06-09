YAML		=	docker-compose.yml
SRCS		=	./srcs/

CONTS		=	mariadb wordpress nginx phpmyadmin cloudflared

COMPOSE		= 	docker compose

all		:	up

up		:
			@(cd $(SRCS) && $(COMPOSE) -f $(YAML) up --build -d)

down	:
			@(cd $(SRCS) && $(COMPOSE) -f $(YAML) down)

start	:
			@(cd $(SRCS) && $(COMPOSE) -f $(YAML) start)

stop	:
			@(cd $(SRCS) && $(COMPOSE) -f $(YAML) stop)

ps		:
			@(cd $(SRCS) && $(COMPOSE) -f $(YAML) ps)

rm		:
			@(cd $(SRCS) && $(COMPOSE) -f $(YAML) rm $(CONTS))
			@(cd $(SRCS) && $(COMPOSE) -f $(YAML) down --volumes)

config	:
			@(cd $(SRCS) && $(COMPOSE) -f $(YAML) config)

bash_mariadb	:
			@(cd $(SRCS) && $(COMPOSE) -f $(YAML) exec mariadb /bin/bash)

bash_wordpress	:
			@(cd $(SRCS) && $(COMPOSE) -f $(YAML) exec wordpress /bin/bash)

bash_nginx	:
			@(cd $(SRCS) && $(COMPOSE) -f $(YAML) exec nginx /bin/bash)

bash_phpmyadmin	:
			@(cd $(SRCS) && $(COMPOSE) -f $(YAML) exec phpmyadmin /bin/bash)

re		:	stop rm all

.PHONY	:	all up down start stop ps rm config