.PHONY: vote vote-rm elk elk-rm portainer portainer-rm build

build:
	docker-compose -f docker-compose.yml -f resources/docker-compose.build.yml build

vote:
	docker stack up voting-app -c docker-stack.yml

vote-rm:
	docker stack rm voting-app

elk:
	docker stack up elk -c resources/elk-stack.yml

elk-rm:
	docker stack rm elk

portainer:
	docker stack up portainer -c resources/portainer-stack.yml

portainer-rm:
	docker stack rm portainer

sync:
	rsync -r ./ ubuntu@pierre1.training.crafteo.io:~

stats:
	docker ps -q | xargs docker stats --no-stream
