IMAGE_NAME := "healthchecker"
IMAGE_TAG := "latest"

image:
	@docker build --progress=plain -t $(IMAGE_NAME):$(IMAGE_TAG) .

all-images:
	@docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 --progress=plain -t $(IMAGE_NAME):$(IMAGE_TAG) .

amd64-image:
	@docker buildx build --platform linux/amd64 --progress=plain -t $(IMAGE_NAME):$(IMAGE_TAG) .

arm64-image:
	@docker buildx build --platform linux/arm64 --progress=plain -t $(IMAGE_NAME):$(IMAGE_TAG) .
