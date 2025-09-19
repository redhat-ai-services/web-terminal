# Image URL to use all building/pushing image targets
REPOSITORY ?= $(REGISTRY)/redhat-ai-services/web-terminal
REGISTRY ?= quay.io
TAGS ?= $(TAGS)
IMG := $(REPOSITORY):$(TAGS)

# podman Login
podman-login:
	@podman login -u $(PODMAN_USER) -p $(PODMAN_PASSWORD) $(REGISTRY)

# Build the podman image
podman-build:
	podman build --platform linux/amd64 . -t ${IMG} -t ${IMG}-x86_64 -f Containerfile

# Push the podman image
podman-push: podman-build
	podman push ${IMG}
	podman push ${IMG}-x86_64
