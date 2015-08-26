
NAME="equilo"
FULL_NAME="andersjanmyr/$(NAME)"

.PHONY: build
build:
	docker build $(FULL_NAME) .


.PHONY: publish
publish:
	docker push $(FULL_NAME)

.PHONY: run
run:
	docker run --publish 3000:80 -it $(FULL_NAME) --name $(NAME)

.PHONY: deploy
deploy:
	ddeploy equilo equilo.se,www.equilo.se
