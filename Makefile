UID=$(shell id -u)
GID=$(shell id -g)
ENABLE_PYTHON=true
ENABLE_GO=true
ENABLE_RUST=true

dev-build:
	uid=${UID} gid=${GID} \
		enable_python=${ENABLE_PYTHON} \
		enable_go=${ENABLE_GO} \
		enable_rust=${ENABLE_RUST} \
		docker-compose build

dev-run:
	docker-compose run --rm dev

dev-down:
	docker-compose down
