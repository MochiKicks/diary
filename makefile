WORKDIR = $(shell pwd)

CSS_DIR = public/css
CSS_FILE = $(CSS_DIR)/main.css
CSS_REV = main-$(shell md5 -r $(WORKDIR)/$(CSS_FILE) | awk '{print $$1}').css

server:
	hugo server --theme=mochi --buildDrafts --watch

asset:
	cp $(CSS_FILE) "$(CSS_DIR)/main-$(shell md5 -r $(CSS_FILE) | awk '{print $$1}').css"
	echo $(CSS_REV)
	find public -name "*.html" -print0 | xargs -0 -I filename /bin/bash -c "echo filename; sed 's/css\/main.css/css\/$(CSS_REV)/g' filename > tmp; mv tmp filename"

generate:
	hugo -t mochi

build: generate

build_draft:
	hugo --theme=mochi --buildDrafts

deploy:
	ssh kurei@axcoto.com "cd /srv/http/domain/maylyn/current; \
									git pull origin master; \
									sudo chgrp -R www-data /srv/http/domain/maylyn; \
									sudo chmod -R g+rx /srv/http/domain/maylyn"
