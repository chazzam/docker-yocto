TAG_ORG = chazzam
TAG_NAME = yocto
TAG_FLAVOR = bionic
TAG_BUILD = 2
TAG_FLAVOR_LATEST = $(TAG_ORG)/$(TAG_NAME):$(TAG_FLAVOR)
TAG_FLAVOR_BUILD = $(TAG_FLAVOR_LATEST)-$(TAG_BUILD)
BUILD_SCRIPT = $(TAG_ORG)-$(TAG_NAME)-$(TAG_FLAVOR)

all:
	docker build --build-arg IMAGE=$(TAG_FLAVOR_BUILD) . -t $(TAG_FLAVOR_BUILD) -t $(TAG_FLAVOR_LATEST) -t $(TAG_ORG)/$(TAG_NAME):latest

script:
	docker run --rm $(TAG_FLAVOR_LATEST) > $(BUILD_SCRIPT)
	chmod +x $(BUILD_SCRIPT)
