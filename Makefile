UID=$(shell id -u)
GID=$(shell id -g)

dev-build:
	uid=${UID} gid=${GID} docker-compose build

dev-run:
	uid=${UID} gid=${GID} docker-compose run --rm dev

dev-down:
	uid=${UID} gid=${GID} docker-compose down
