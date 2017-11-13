# gymongonasium

Container to work out a mongodb instance

As a minimum you will want to specify the mongo host:

```
	docker run \
		-d \
		--name gymongonasium \
		--link mongodb:mongodb \
		--cidfile .gymongonasium.cid \
		-e GYMONGODB_DB=${GYMONGODB_DB} \
		joshuacox/gymongonasium
```

There are a few env vars you can set:

```
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
		joshuacox/gymongonasium
```

### Makefile

There is a makefile for convenience to test things out.

`make build` will build everything sysbench and mongorover from source

`make run` will run a mongodb instance and the above built container
will test it

`make logs` to watch the log output

`make enter` to enter the running sysbench container

`make clean` will destroy the running containers and cleanup

`make binbuild` will test out the packages binaries (*broken for now as
mongorover is out of date)
