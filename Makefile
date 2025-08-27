# Image URL to use all building/pushing image targets
REPOSITORY ?= $(REGISTRY)/eformat/web-terminal
REGISTRY ?= quay.io

IMG := $(REPOSITORY):latest
VERSION := 1.0.0

# podman Login
podman-login:
	@podman login -u $(PODMAN_USER) -p $(PODMAN_PASSWORD) $(REGISTRY)

# Tag for Dev
podman-tag-release:
	@podman tag $(IMG) $(REPOSITORY):$(VERSION)
	@podman tag $(REPOSITORY):$(VERSION) $(REPOSITORY):latest

# Push for Release
podman-push-release: podman-tag-release
	@podman push $(REPOSITORY):$(VERSION)
	@podman push $(REPOSITORY):latest

# Build the podman image
podman-build:
	podman build --platform linux/amd64 . -t ${IMG} -t ${IMG}-x86_64 -f Containerfile

# Push the podman image
podman-push: podman-build
	podman push ${IMG}
	podman push ${IMG}-x86_64

podman-push-all: podman-build podman-push-release
