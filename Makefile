#!/usr/bin/make -f
NAME=jamesbrink/php
TEMPLATE=Dockerfile.template
DOCKER_COMPOSE_TEMPLATE=docker-compose.template
.PHONY: test all clean 7.2 7.1 7.0 test-7.2 test-7.1 test-7.0
.DEFAULT_GOAL := 7.2

# Verification SHAs
PHP_7.2.3_SHA="b3a94f1b562f413c0b96f54bc309706d83b29ac65d9b172bc7ed9fb40a5e651f"
PHP_7.1.15_SHA="0e17192fb43532e4ebaa190ecec9c7e59deea7dadb7dab67b19c2081a68bd817"
PHP_7.0.28_SHA="e738ffce2c30bc0e84be9446af86bef0a0607d321f1a3d04bbfe2402fb5f6de0"

all: 7.2 7.1 7.0

7.2:
	mkdir -p $(@)
	cp -rp docker-assets $(@)
	cp -rp hooks $(@)
	cp Dockerfile.template $(@)/Dockerfile
	cp .dockerignore $(@)/.dockerignore
	sed -i -r 's/ARG PHP_VERSION.*/ARG PHP_VERSION="7.2.3"/g' $(@)/Dockerfile
	sed -i -r 's/ARG PHP_SHA256.*/ARG PHP_SHA256=$(PHP_7.2.3_SHA)/g' $(@)/Dockerfile
	cd $(@) && PHP_VERSION="7.2.3" PHP_SHA256=$(PHP_7.2.3_SHA) IMAGE_NAME=$(NAME):$(@) ./hooks/build
	docker tag $(NAME):$(@) $(NAME):latest

7.1:
	mkdir -p $(@)
	cp -rp docker-assets $(@)
	cp -rp hooks $(@)
	cp Dockerfile.template $(@)/Dockerfile
	cp .dockerignore $(@)/.dockerignore
	sed -i -r 's/ARG PHP_VERSION.*/ARG PHP_VERSION="7.1.15"/g' $(@)/Dockerfile
	sed -i -r 's/ARG PHP_SHA256.*/ARG PHP_SHA256=$(PHP_7.1.15_SHA)/g' $(@)/Dockerfile
	cd $(@) && PHP_VERSION="7.1.15" PHP_SHA256=$(PHP_7.1.15_SHA) IMAGE_NAME=$(NAME):$(@) ./hooks/build

7.0:
	mkdir -p $(@)
	cp -rp docker-assets $(@)
	cp -rp hooks $(@)
	cp Dockerfile.template $(@)/Dockerfile
	cp .dockerignore $(@)/.dockerignore
	sed -i -r 's/ARG PHP_VERSION.*/ARG PHP_VERSION="7.0.28"/g' $(@)/Dockerfile
	sed -i -r 's/ARG PHP_SHA256.*/ARG PHP_SHA256=$(PHP_7.0.28_SHA)/g' $(@)/Dockerfile
	cd $(@) && PHP_VERSION="7.0.28" PHP_SHA256=$(PHP_7.0.28_SHA) IMAGE_NAME=$(NAME):$(@) ./hooks/build

test: test-7.0 test-7.1 test-7.2

test-7.0:
	if [ "`docker run jamesbrink/php:7.0 -r 'echo phpversion(), PHP_EOL;'`" != "7.0.28" ]; then exit 1;fi

test-7.1:
	if [ "`docker run jamesbrink/php:7.1 -r 'echo phpversion(), PHP_EOL;'`" != "7.1.15" ]; then exit 1;fi

test-7.2:
	if [ "`docker run jamesbrink/php:7.2 -r 'echo phpversion(), PHP_EOL;'`" != "7.2.3" ]; then exit 1;fi

clean:
	rm -rf 7.2 7.1 7.0
