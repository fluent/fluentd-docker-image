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
ALL_IMAGES := \
	v0.12/alpine:v0.12.32,v0.12,stable,latest \
	v0.12/alpine-onbuild:v0.12.32-onbuild,v0.12-onbuild,stable-onbuild,onbuild \
	v0.12/debian:v0.12.32-debian,v0.12-debian,stable-debian,debian \
	v0.12/debian-onbuild:v0.12.32-debian-onbuild,v0.12-debian-onbuild,stable-debian-onbuild,debian-onbuild \
	v0.14/alpine:v0.14.13,v0.14,edge \
	v0.14/alpine-onbuild:v0.14.13-onbuild,v0.14-onbuild,edge-onbuild \
	v0.14/debian:v0.14.13-debian,v0.14-debian,edge-debian \
	v0.14/debian-onbuild:v0.14.13-debian-onbuild,v0.14-debian-onbuild,edge-debian-onbuild
#	<Dockerfile>:<version>,<tag1>,<tag2>,...


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
	docker build $(no-cache-arg) -t $(IMAGE_NAME):$(VERSION) $(DOCKERFILE)



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

src: dockerfile fluent.conf post-push-hook



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
        test test-all deps.bats
