default: build push deploy


APPLICATION ?= squid
TAG ?= $(shell git describe --tags --abbrev=0)

build:
        . ./env
        docker build --tag ${REGISTRY}:5000/${APPLICATION}:${TAG} --build-arg VCS_REF=`git rev-parse --short HEAD` --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` .

push:
        . ./env
        docker push ${REGISTRY}:5000/${APPLICATION}:${TAG}

deploy:
        . ./env
        docker stack deploy --with-registry-auth --compose-file syslog.yml syslog
        sed -i "s/SYSLOG_SERVER/${REGISTRY}/g" config/squid/syslog.conf
        docker stack deploy --with-registry-auth --compose-file squid.yml proxy   
