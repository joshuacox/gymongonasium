# gymongonasium

Container to work out a mongodb instance

### Makefile

There is a makefile for convenience to test things out.

`make build` will build sysbench and mongorover image from source

`make pull` or you can pull it from dockerhub

`make run` will run a mongodb instance and the above built container
will test it

`make logs` to watch the log output

`make enter` to enter the running sysbench container

`make clean` will destroy the running containers and cleanup

`make binbuild` will test out the packages binaries (*broken for now as
mongorover is out of date)

### env vars

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

you can also echo values out into this directory and they will be
gitignored, but also read in upon starting the make recipes.  e.g.

```
echo 240>TIME
echo 55>THREADS
```
