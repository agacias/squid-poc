default: build push deploy

build:
	. ./env
	docker build --tag ${REGISTRY}:5000/squid:${TAG} --build-arg VCS_REF=`git rev-parse --short HEAD` --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` ./squid
	docker build --tag ${REGISTRY}:5000/rsyslog:${TAG} --build-arg VCS_REF=`git rev-parse --short HEAD` --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` ./rsyslog
        
push:
	. ./env
	docker push ${REGISTRY}:5000/squid:${TAG}
	docker push ${REGISTRY}:5000/rsyslog:${TAG}

deploy:
	. ./env
	
	mkdir -p /var/log/rsyslog

	docker stack deploy --with-registry-auth --compose-file rsyslog/rsyslog.yml rsyslog
	docker stack deploy --with-registry-auth --compose-file squid/squid.yml squid  
