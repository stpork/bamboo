IMAGE_NAME = bamboo
REPOSITORY = stpork

.PHONY: build
build:
	docker build -t $(IMAGE_NAME) .
	docker tag ${IMAGE_NAME} ${REPOSITORY}/${IMAGE_NAME}

.PHONY: rebuild
build:
	docker build --no-cache -t $(IMAGE_NAME) .
	docker tag ${IMAGE_NAME} ${REPOSITORY}/${IMAGE_NAME}

.PHONY: test
test:
	docker build -t $(IMAGE_NAME)-candidate .
	IMAGE_NAME=$(IMAGE_NAME)-candidate test/run
