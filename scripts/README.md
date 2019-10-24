# scripts

* `docker-swarm-prep.sh` is used to prepare a host for being a docker swarm host.
  * It takes a list of hosts in a file
  * Enables docker-swarm port communication only from the hosts in the file
  * all other hosts will be blocked from talking on the specified ports