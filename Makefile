default: build push deploy

build:
	. ./env
	docker build -f Dockerfile-squid --tag ${REGISTRY}:5000/squid:${TAG} --build-arg VCS_REF=`git rev-parse --short HEAD` --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` .
	docker build -f Dockerfile-rsyslog --tag ${REGISTRY}:5000/rsyslog:${TAG} --build-arg VCS_REF=`git rev-parse --short HEAD` --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` .
        
push:
	. ./env
	docker push ${REGISTRY}:5000/squid:${TAG}
	docker push ${REGISTRY}:5000/rsyslog:${TAG}

deploy:
	. ./env
	docker stack deploy --with-registry-auth --compose-file rsyslog.yml rsyslog
	docker stack deploy --with-registry-auth --compose-file squid.yml proxy   
