# squid-poc
POC


## desplegar en swarm

git clone https://github.com/agacias/squid-poc.git

cd squid-poc

. ./env

bash registry-pwd.sh 

make 

tail -f /var/log/rsyslog/rsyslog

Enlaces de interes:

[Cache Digests](https://etutorials.org/Server+Administration/Squid.+The+definitive+guide/Chapter+10.+Talking+to+Other+Squids/10.7+Cache+Digests/)
