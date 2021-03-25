UID=$(shell id -u)
GID=$(shell id -g)
# below must be blank to disable!
ENABLE_PYTHON=true
ENABLE_GO=true
ENABLE_RUST=true
ENABLE_TEX=""

dev-build:
	uid=${UID} gid=${GID} \
		enable_python=${ENABLE_PYTHON} \
		enable_go=${ENABLE_GO} \
		enable_rust=${ENABLE_RUST} \
		enable_tex=${ENABLE_TEX} \
		docker-compose build

dev-run: dev-build
	docker-compose run --rm dev

dev-down:
	docker-compose down
