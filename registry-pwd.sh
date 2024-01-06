#!/bin/bash

# Instala un registry en https://labs.play-with-docker.com/
# ===========================================================
#
# Ejecuta este script en un manager de SWARM.
#
# test:
#     docker pull nginx
#     docker tag nginx registry.red.zaragoza.es:5000/nginx
#     docker push registry.red.zaragoza.es:5000/nginx
#     docker pull registry.red.zaragoza.es:5000/nginx

source ./env


mkdir -p ${PATH_REGISTRY}/data || :
mkdir -p ${PATH_REGISTRY}/certs || :
cd ${PATH_REGISTRY}
 
# Generate Certificate
cd certs

# Create a CA crt

openssl req -new -x509 -nodes -newkey rsa:4096 -extensions v3_ca -sha256 -days 3650 -subj "/C=ES/ST=ZARAGOZA/L=ZARAGOZA/O=migasfree/CN=${REGISTRY}" -keyout ca.key -out ca.crt
chmod 600 ca.key

# Create a CSR:
openssl req -newkey rsa:2048 -nodes -sha256 -keyout ${REGISTRY}.key -out ${REGISTRY}.csr -subj "/C=ES/ST=ZARAGOZA/L=ZARAGOZA/O=migasfree/OU=Core/CN=${REGISTRY}"

# Check contents of CSR (optional):
# openssl req -in ${REGISTRY}.csr -text -noout

# Sign the CSR, resulting in CRT and add the v3 SAN extension:
openssl x509 -req -in ${REGISTRY}.csr -out ${REGISTRY}.crt -CA ca.crt -CAkey ca.key -CAcreateserial -sha256 -days 1095 -extensions SAN -extfile <(cat  /etc/ssl/openssl.cnf <(printf "[SAN]\nsubjectAltName=@san_names\nbasicConstraints=CA:FALSE\nkeyUsage=nonRepudiation,digitalSignature,keyEncipherment\n[san_names]\nDNS.1=${REGISTRY}\n"))
chmod 600 ${REGISTRY}.key

# Check contents of CRT (optional)
#openssl x509 -in ${REGISTRY}.crt -text -noout

cd ..




# Password
apk add apache2-utils
: | sudo tee ./certs/htpasswd
echo "${PASSWORD}" | sudo htpasswd -iB ./certs/htpasswd ${USERNAME}


# Copiamos el certificado de la CA en docker
mkdir -p /etc/docker/certs.d/${REGISTRY}:5000/
cp certs/ca.crt /etc/docker/certs.d/${REGISTRY}:5000/

docker run -d -p 5000:5000 --name registry -v $(pwd)/data:/var/lib/registry -v $(pwd)/certs:/etc/security -e REGISTRY_HTTP_TLS_CERTIFICATE=/etc/security/${REGISTRY}.crt -e REGISTRY_HTTP_TLS_KEY=/etc/security/${REGISTRY}.key -e REGISTRY_AUTH=htpasswd -e REGISTRY_AUTH_HTPASSWD_PATH=/etc/security/htpasswd -e REGISTRY_AUTH_HTPASSWD_REALM="Registry Realm" --restart always registry:2

sleep 5

# POR CADA NODO
for NODE in $(docker node ls -q)
do
    IP=$(docker node inspect ${NODE} |jq -r .[].Status.Addr)
    scp -o "StrictHostKeyChecking no" certs/ca.crt root@${IP}:/usr/local/share/ca-certificates/
    ssh root@${IP} "update-ca-certificates;echo "${IP_REGISTRY} ${REGISTRY}" >> /etc/hosts ; echo  ${PASSWORD} | docker login ${REGISTRY}:5000 --username ${USERNAME} --password-stdin"
done


exit

# listar las CAs
awk -v cmd='openssl x509 -noout -subject' '
    /BEGIN/{close(cmd)};{print | cmd}' < /etc/ssl/certs/ca-certificates.crt

