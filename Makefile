##
# hverdagsverktoy-db
#
# @file
# @version 0.1



PG_INIT_COMPLETE="PostgreSQL init process complete; ready for start up."

DB_CONTAINER_NAME ?= hverdagsverktoydb

.PHONY: hverdagsverktoydb
hverdagsverktoydb:
	docker network inspect hverdagsverktoy-network >/dev/null 2>&1 || docker network create hverdagsverktoy-network
	docker start $(DB_CONTAINER_NAME) || docker run --name $(DB_CONTAINER_NAME) --network hverdagsverktoy-network --env POSTGRES_USER=root --env POSTGRES_DB=hverdagsverktoy --env POSTGRES_HOST_AUTH_METHOD=trust --detach --publish 5433:5432 postgres:11.1
	# We have to do this because the postgres image stops pg, then restarts it. When it is done it is supposed to print out $(PG_INIT_COMPLETE)
	until docker logs $(DB_CONTAINER_NAME) 2>&1 | grep -q $(PG_INIT_COMPLETE); do sleep 1; done # NB: this will go on forever if it fails
	# Wait until database is ready
	docker exec $(DB_CONTAINER_NAME) pg_isready -U root -d hverdagsverktoy -t 10

# end
