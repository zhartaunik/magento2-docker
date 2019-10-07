# Ecommerce Makefile

SHELL := /bin/bash # Use bash syntax
VERSION := $(shell git rev-list HEAD --count --no-merges)

args = `arg="$(filter-out $(firstword $(MAKECMDGOALS)),$(MAKECMDGOALS))" && echo $${arg:-${1}}`

green  = $(shell echo -e '\x1b[32;01m$1\x1b[0m')
yellow = $(shell echo -e '\x1b[33;01m$1\x1b[0m')
red	= $(shell echo -e '\x1b[33;31m$1\x1b[0m')

format = $(shell printf "%s %-40s %s" "$(call yellow,$1)" "$(call green,$2)" $3)

.DEFAULT_GOAL:=help

.PHONY: install

.SILENT:

%:
	@:

# show some help
help:
	@echo "$(call green,'Use the following commands:')"
	@echo "$(call red,'Help')"
	@echo "$(call format,'make','help','Print list of commands with comment')"

	@echo "$(call red,'Docker')"
	@echo "$(call format,'make','docker:up','Up all containers')"
	@echo "$(call format,'make','docker:magento','Up nginx varnish fpm and mysql containers')"
	@echo "$(call format,'make','docker:down','Down all containers')"
	@echo "$(call format,'make','docker:ps','Show containers statuses')"
	@echo "$(call format,'make','docker:exec','Run container')"
	@echo "$(call format,'make','docker:start','Start container')"
	@echo "$(call format,'make','docker:stop','Stop container')"
	@echo "$(call format,'make','docker:restart','Restart container')"
	@echo "$(call format,'make','docker:build','Start build containers')"

	@echo "$(call red,'Magento')"
	@echo "$(call format,'make','mg','Opens magento application container')"
	@echo "$(call format,'make','cli','Opens magento cli container')"

docker\:up:
	@echo "$(call yellow, 'Up all containers')"
	@docker-compose -f docker-compose.yml up -d

docker\:magento:
	@echo "$(call yellow, 'Up all containers')"
	@docker-compose -f docker-compose.yml up -d redis mysql magento web varnish chrome

docker\:down:
	@echo "$(call yellow, 'Down all containers')"
	@docker-compose down $(call args)

docker\:ps:
	@echo "$(call yellow, 'Show containers statuses')"
	@docker-compose ps $(call args)

docker\:exec:
	@echo "$(call yellow, 'Run container')"
	@docker-compose exec $(call args)

docker\:start:
	@echo "$(call yellow, 'Start container:') $(call red,$(call args))"
	@docker-compose start $(call args)

docker\:stop:
	@echo "$(call yellow, 'Stop container:') $(call red,$(call args))"
	@docker-compose stop $(call args)

docker\:restart:
	@echo "$(call yellow, 'Restart container:') $(call red,$(call args))"
	@docker-compose restart $(call args)

docker\:build:
	@echo "$(call yellow,'Start build containers')"
	@docker-compose -f docker-compose-build.yml -f docker-compose.yml build $(call args)

mg:
	@echo "$(call yellow,'Opens magento application container')"
	@docker-compose -f docker-compose.yml exec magento bash

cli:
	@echo "$(call yellow,'Opens magento cli container')"
	@docker-compose run --rm magento_cli $(call args)