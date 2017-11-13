full: build run logs

build:
	docker build -t `cat TAG` .

binbuild:
	docker build -f Dockerfile.bin.broken -t `cat TAG` .

run: clean .mongodb.cid .gymongonasium.cid

.gymongonasium.cid:
	$(eval TAG := $(shell cat TAG))
	$(eval TABLES := $(shell cat TABLES))
	$(eval TABLE_SIZE := $(shell cat TABLE_SIZE))
	$(eval MONGO_DB_NAME := $(shell cat MONGO_DB_NAME))
	$(eval TABLES := $(shell cat TABLES))
	$(eval TABLES := $(shell cat TABLES))
	docker run \
		-d \
		--name gymongonasium \
		--link mongodb:mongodb \
		--cidfile .gymongonasium.cid \
		-e VERBOSITY=1 \
		$(TAG)

.mongodb.cid:
	$(eval TRY := $(shell cat TRY))
	docker run --name mongodb \
		-d \
		--cidfile=.mongodb.cid \
	  mongo:3.4

enter:
	docker exec -it \
		`cat .gymongonasium.cid` \
		/bin/bash

kill:
	-@docker kill `cat .gymongonasium.cid`
	-@docker kill `cat .mongodb.cid`

clean:
	bash ./scripts/clean

logs:
	docker logs -f `cat .gymongonasium.cid`
