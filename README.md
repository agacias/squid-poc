# squid-poc
POC


## desplegar en swarm

git clone https://github.com/agacias/squid-poc.git

cd squid-poc

. ./env

bash registry-pwd.sh 

make 

tail -f /var/log/rsyslog/rsyslog
