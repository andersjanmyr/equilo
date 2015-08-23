
.PHONY: build
build:
	docker build -t andersjanmyr/equilo .


.PHONY: publish
publish:
	docker push andersjanmyr/equilo

.PHONY: run
run:
	docker run --publish 3000:80 --name equilo --rm -it andersjanmyr/equilo
