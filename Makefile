default: build push deploy

REGISTRY ?= registry.red.zaragoza.es:5000

APPLICATION ?= squid
TAG ?= $(shell git describe --tags --abbrev=0)

build:
         docker build --tag ${REGISTRY}/${APPLICATION}:${TAG} --build-arg VCS_REF=`git rev-parse --short HEAD` --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` .

push:
         docker push ${REGISTRY}/${APPLICATION}:${TAG}

deploy:
         docker stack deploy --compose-file squid.yml proxy
