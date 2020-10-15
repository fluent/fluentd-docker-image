# This Makefile automates possible operations of this project.
#
# Images and description on Docker Hub will be automatically rebuilt on
# pushes to `master` branch of this repo and on updates of parent images.
#
# Note! Docker Hub `post_push` hook must be always up-to-date with values
# specified in current Makefile. To update it just use:
#	make post-push-hook-all
#
# It's still possible to build, tag and push images manually. Just use:
#	make release-all


IMAGE_NAME := fluent/fluentd
X86_IMAGES := \
	v1.11/alpine:v1.11.4-2.0,v1.11-2,edge \
	v1.11/debian:v1.11.4-debian-1.0,v1.11-debian-1,edge-debian \
	v1.11/windows:v1.11.4-windows-1.0,v1.11-windows-1
#	<Dockerfile>:<version>,<tag1>,<tag2>,...

# Define images for running on ARM platforms
ARM_IMAGES := \
	v1.11/armhf/debian:v1.11.4-debian-armhf-1.0,v1.11-debian-armhf-1,edge-debian-armhf \

# Define images for running on ARM64 platforms
ARM64_IMAGES := \
	v1.11/arm64/debian:v1.11.4-debian-arm64-1.0,v1.11-debian-arm64-1,edge-debian-arm64 \

ALL_IMAGES := $(X86_IMAGES) $(ARM_IMAGES) $(ARM64_IMAGES)

# Default is first image from ALL_IMAGES list.
DOCKERFILE ?= $(word 1,$(subst :, ,$(word 1,$(ALL_IMAGES))))
VERSION ?=  $(word 1,$(subst $(comma), ,\
                     $(word 2,$(subst :, ,$(word 1,$(ALL_IMAGES))))))
TAGS ?= $(word 2,$(subst :, ,$(word 1,$(ALL_IMAGES))))

no-cache ?= no



comma := ,
empty :=
space := $(empty) $(empty)
eq = $(if $(or $(1),$(2)),$(and $(findstring $(1),$(2)),\
                                $(findstring $(2),$(1))),1)



# Build Docker image.
#
# Usage:
#	make image [no-cache=(yes|no)] [DOCKERFILE=] [VERSION=]

no-cache-arg = $(if $(call eq, $(no-cache), yes), --no-cache, $(empty))

image:
	docker build $(no-cache-arg) -t $(IMAGE_NAME):$(VERSION) $(DOCKERFILE) --build-arg VERSION=$(VERSION)



# Tag Docker image with given tags.
#
# Usage:
#	make tags [VERSION=] [TAGS=t1,t2,...]

parsed-tags = $(subst $(comma), $(space), $(TAGS))

tags:
	(set -e ; $(foreach tag, $(parsed-tags), \
		docker tag $(IMAGE_NAME):$(VERSION) $(IMAGE_NAME):$(tag) ; \
	))



# Manually push Docker images to Docker Hub.
#
# Usage:
#	make push [TAGS=t1,t2,...]

push:
	(set -e ; $(foreach tag, $(parsed-tags), \
		docker push $(IMAGE_NAME):$(tag) ; \
	))



# Make manual release of Docker images to Docker Hub.
#
# Usage:
#	make release [no-cache=(yes|no)] [DOCKERFILE=] [VERSION=] [TAGS=t1,t2,...]

release: | image tags push



# Make manual release of all supported Docker images to Docker Hub.
#
# Usage:
#	make release-all [no-cache=(yes|no)]

release-all:
	(set -e ; $(foreach img,$(ALL_IMAGES), \
		make release no-cache=$(no-cache) \
			DOCKERFILE=$(word 1,$(subst :, ,$(img))) \
			VERSION=$(word 1,$(subst $(comma), ,\
			                 $(word 2,$(subst :, ,$(img))))) \
			TAGS=$(word 2,$(subst :, ,$(img))) ; \
	))



# Generate Docker image sources.
#
# Usage:
#	make src [DOCKERFILE=] [VERSION=] [TAGS=t1,t2,...]

src: dockerfile fluent.conf entrypoint.sh post-push-hook post-checkout-hook



# Generate sources for all supported Docker images.
#
# Usage:
#	make src-all

src-all:
	(set -e ; $(foreach img,$(ALL_IMAGES), \
		make src \
			DOCKERFILE=$(word 1,$(subst :, ,$(img))) \
			VERSION=$(word 1,$(subst $(comma), ,\
			                 $(word 2,$(subst :, ,$(img))))) \
			TAGS=$(word 2,$(subst :, ,$(img))) ; \
	))



# Generate Dockerfile from template.
#
# Usage:
#	make dockerfile [DOCKERFILE=] [VERSION=]

dockerfile:
	mkdir -p $(DOCKERFILE)
	docker run --rm -i -v $(PWD)/Dockerfile.template.erb:/Dockerfile.erb:ro \
		ruby:alpine erb -U -T 1 \
			dockerfile='$(DOCKERFILE)' \
			version='$(VERSION)' \
		/Dockerfile.erb > $(DOCKERFILE)/Dockerfile



# Generate Dockerfile from template for all supported Docker images.
#
# Usage:
#	make dockerfile-all

dockerfile-all:
	(set -e ; $(foreach img,$(ALL_IMAGES), \
		make dockerfile \
			DOCKERFILE=$(word 1,$(subst :, ,$(img))) \
			VERSION=$(word 1,$(subst $(comma), ,\
			                 $(word 2,$(subst :, ,$(img))))) ; \
	))



# Generate fluent.conf from template.
#
# Usage:
#	make fluent.conf [DOCKERFILE=] [VERSION=]

fluent.conf:
	mkdir -p $(DOCKERFILE)
	docker run --rm -i -v $(PWD)/fluent.conf.erb:/fluent.conf.erb:ro \
		ruby:alpine erb -U -T 1 \
			version='$(VERSION)' \
		/fluent.conf.erb > $(DOCKERFILE)/fluent.conf



# Generate fluent.conf from template for all supported Docker images.
#
# Usage:
#	make fluent.conf-all

fluent.conf-all:
	(set -e ; $(foreach img,$(ALL_IMAGES), \
		make fluent.conf \
			DOCKERFILE=$(word 1,$(subst :, ,$(img))) \
			VERSION=$(word 1,$(subst $(comma), ,\
			                 $(word 2,$(subst :, ,$(img))))) ; \
	))

# Generate entrypoint.sh from template.
#
# Usage:
#	make entrypoint.sh [DOCKERFILE=] [VERSION=]

entrypoint.sh:
	mkdir -p $(DOCKERFILE)
	docker run --rm -i -v $(PWD)/entrypoint.sh.erb:/entrypoint.sh.erb:ro \
		ruby:alpine erb -U -T 1 \
			dockerfile='$(DOCKERFILE)' \
			version='$(VERSION)' \
		/entrypoint.sh.erb > $(DOCKERFILE)/entrypoint.sh
	chmod +x $(DOCKERFILE)/entrypoint.sh



# Generate entrypoint.sh from template for all supported Docker images.
#
# Usage:
#	make entrypoint.sh-all

entrypoint.sh-all:
	(set -e ; $(foreach img,$(ALL_IMAGES), \
		make entrypoint.sh \
			DOCKERFILE=$(word 1,$(subst :, ,$(img))) \
			VERSION=$(word 1,$(subst $(comma), ,\
			                 $(word 2,$(subst :, ,$(img))))) ; \
	))


# Create `post_push` Docker Hub hook.
#
# When Docker Hub triggers automated build all the tags defined in `post_push`
# hook will be assigned to built image. It allows to link the same image with
# different tags, and not to build identical image for each tag separately.
# See details:
# http://windsock.io/automated-docker-image-builds-with-multiple-tags
#
# Usage:
#	make post-push-hook [DOCKERFILE=] [TAGS=t1,t2,...]

post-push-hook:
	mkdir -p $(DOCKERFILE)/hooks
	docker run --rm -i -v $(PWD)/post_push.erb:/post_push.erb:ro \
		ruby:alpine erb -U \
			image_tags='$(TAGS)' \
		/post_push.erb > $(DOCKERFILE)/hooks/post_push



# Create `post_push` Docker Hub hook for all supported Docker images.
#
# Usage:
#	make post-push-hook-all

post-push-hook-all:
	(set -e ; $(foreach img,$(ALL_IMAGES), \
		make post-push-hook \
			DOCKERFILE=$(word 1,$(subst :, ,$(img))) \
			TAGS=$(word 2,$(subst :, ,$(img))) ; \
	))



# Create `post_checkout` Docker Hub hook.
#
# When Docker Hub triggers automated build, the `post_checkout` hook is called
# after the Git repo is checked out. This can be used to set up prerequisites
# for, for example, cross-platform builds.
# See details:
# https://docs.docker.com/docker-cloud/builds/advanced/#build-hook-examples
#
# Usage:
#	make post-checkout-hook [DOCKERFILE=]

post-checkout-hook:
	if [ -n "$(findstring /armhf/,$(DOCKERFILE))" ] || [ -n "$(findstring /arm64/,$(DOCKERFILE))" ]; then \
		mkdir -p $(DOCKERFILE)/hooks; \
		docker run --rm -i -v $(PWD)/post_checkout.erb:/post_checkout.erb:ro \
			ruby:alpine erb -U \
				dockerfile='$(DOCKERFILE)' \
			/post_checkout.erb > $(DOCKERFILE)/hooks/post_checkout ; \
	fi


# Create `post_push` Docker Hub hook for all supported Docker images.
#
# Usage:
#	make post-checkout-hook-all

post-checkout-hook-all:
	(set -e ; $(foreach img,$(ALL_IMAGES), \
		make post-checkout-hook \
			DOCKERFILE=$(word 1,$(subst :, ,$(img))) ; \
	))



# Run tests for Docker image.
#
# Usage:
#	make test [DOCKERFILE=] [VERSION=]

test: deps.bats
	DOCKERFILE=$(DOCKERFILE) IMAGE=$(IMAGE_NAME):$(VERSION) \
		./test/bats/bats test/suite.bats



# Run tests for all supported Docker images.
#
# Usage:
#	make test-all [prepare-images=(no|yes)]

prepare-images ?= no

test-all:
ifeq ($(prepare-images),yes)
	(set -e ; $(foreach img,$(ALL_IMAGES), \
		make image no-cache=$(no-cache) \
			DOCKERFILE=$(word 1,$(subst :, ,$(img))) \
			VERSION=$(word 1,$(subst $(comma), ,\
			                 $(word 2,$(subst :, ,$(img))))) ; \
	))
endif
	(set -e ; $(foreach img,$(ALL_IMAGES), \
		make test \
			DOCKERFILE=$(word 1,$(subst :, ,$(img))) \
			VERSION=$(word 1,$(subst $(comma), ,\
			                 $(word 2,$(subst :, ,$(img))))) ; \
	))



# Resolve project dependencies for running Bats tests.
#
# Usage:
#	make deps.bats [BATS_VER=]

BATS_VER ?= 0.4.0

deps.bats:
ifeq ($(wildcard $(PWD)/test/bats),)
	mkdir -p $(PWD)/test/bats/vendor
	wget https://github.com/sstephenson/bats/archive/v$(BATS_VER).tar.gz \
		-O $(PWD)/test/bats/vendor/bats.tar.gz
	tar -xzf $(PWD)/test/bats/vendor/bats.tar.gz \
		-C $(PWD)/test/bats/vendor
	rm -f $(PWD)/test/bats/vendor/bats.tar.gz
	ln -s $(PWD)/test/bats/vendor/bats-$(BATS_VER)/libexec/* \
		$(PWD)/test/bats/
endif



.PHONY: image tags push \
        release release-all \
        src src-all \
        dockerfile dockerfile-all \
        fluent.conf fluent.conf-all \
        post-push-hook post-push-hook-all \
		post-checkout-hook post-checkout-hook-all \
        test test-all deps.bats
