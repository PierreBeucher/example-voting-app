.PHONY: vote vote-rm elk elk-rm portainer portainer-rm build

build:
	docker-compose -f docker-compose.yml -f resources/docker-compose.build.yml build

elk:
	docker compose -f resources/elk-stack.yml up -d 

elk-down:
	docker compose -f resources/elk-stack.yml down -v

logging:
	docker compose -f docker-compose.yml -f resources/logging.yml up -d 

portainer:
	docker compose -f resources/portainer.yml up -d 

traefik:
	docker compose -f docker-compose.yml -f resources/traefik.yml up -d