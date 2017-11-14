full: build run logs

build:
	docker build -t `cat TAG` .

binbuild:
	docker build -f Dockerfile.bin.broken -t `cat TAG` .

run: clean .mongodb.cid .gymongonasium.cid

.gymongonasium.cid:
	$(eval TAG := $(shell cat TAG))
	$(eval TIME := $(shell cat TIME))
	$(eval SLEEP := $(shell cat SLEEP))
	$(eval TABLES := $(shell cat TABLES))
	$(eval THREADS := $(shell cat THREADS))
	$(eval TABLE_SIZE := $(shell cat TABLE_SIZE))
	$(eval RANGE_SIZE := $(shell cat RANGE_SIZE))
	$(eval SUM_RANGES := $(shell cat SUM_RANGES))
	$(eval GYMONGODB_DB := $(shell cat GYMONGODB_DB))
	$(eval GYMONGODB_HOST := $(shell cat GYMONGODB_HOST))
	$(eval GYMONGODB_PORT := $(shell cat GYMONGODB_PORT))
	docker run \
		-d \
		--name gymongonasium \
		--link mongodb:mongodb \
		--cidfile .gymongonasium.cid \
		-e VERBOSITY=1 \
		-e TIME=${TIME} \
		-e SLEEP=${SLEEP} \
		-e TABLES=${TABLES} \
		-e THREADS=${THREADS} \
		-e TABLE_SIZE=${TABLE_SIZE} \
		-e RANGE_SIZE=${RANGE_SIZE} \
		-e SUM_RANGES=${SUM_RANGES} \
		-e GYMONGODB_DB=${GYMONGODB_DB} \
		-e GYMONGODB_HOST=${GYMONGODB_HOST} \
		-e GYMONGODB_PORT=${GYMONGODB_PORT} \
		-e GYMONGO_SYSBENCH=0 \
		-e GYMONGO_PYTHON=1 \
		$(TAG)

bash: clean .mongodb.cid
	$(eval TAG := $(shell cat TAG))
	$(eval TIME := $(shell cat TIME))
	$(eval SLEEP := $(shell cat SLEEP))
	$(eval TABLES := $(shell cat TABLES))
	$(eval THREADS := $(shell cat THREADS))
	$(eval TABLE_SIZE := $(shell cat TABLE_SIZE))
	$(eval GYMONGODB_DB := $(shell cat GYMONGODB_DB))
	$(eval GYMONGODB_HOST := $(shell cat GYMONGODB_HOST))
	$(eval GYMONGODB_PORT := $(shell cat GYMONGODB_PORT))
	docker run \
		-d \
		--name gymongonasium \
		--link mongodb:mongodb \
		--cidfile .gymongonasium.cid \
		-e VERBOSITY=1 \
		-e TIME=${TIME} \
		-e SLEEP=${SLEEP} \
		-e TABLES=${TABLES} \
		-e THREADS=${THREADS} \
		-e TABLE_SIZE=${TABLE_SIZE} \
		-e GYMONGODB_DB=${GYMONGODB_DB} \
		-e GYMONGODB_HOST=${GYMONGODB_HOST} \
		-e GYMONGODB_PORT=${GYMONGODB_PORT} \
		-e GYMONGO_SYSBENCH=0 \
		-e GYMONGO_PYTHON=1 \
		$(TAG) \
		/bin/bash

sysbench: clean .mongodb.cid sysbenchrun logs

sysbenchrun:
	$(eval TAG := $(shell cat TAG))
	$(eval THREADS := $(shell cat THREADS))
	docker run \
		-d \
		--name gymongonasium \
		--link mongodb:mongodb \
		--cidfile .gymongonasium.cid \
		-e VERBOSITY=1 \
		-e GYMONGO_SYSBENCH=1 \
		-e THREADS=${THREADS} \
		-e GYMONGO_PYTHON=0 \
		$(TAG)

pull:
	$(eval TAG := $(shell cat TAG))
	docker pull $(TAG)

.mongodb.cid:
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
