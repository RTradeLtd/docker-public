#! /bin/bash

# prepares a host for docker swarm usage by making access to the ports more restricted

function error_handle() {
    if [[ "$?" != 0 ]]; then
        echo "[ERROR] the last command failed, see logs for details"
        exit 1
    fi
}


HOSTS_FILE="$1"

if [[ "$HOSTS_FILE" == "" ]]; then
    echo "invalid invocation:"
    echo "./docker-swarm-prep.sh <hosts-file>"
    echo "hosts-file: a list of hosts to enable connection sfrom"
    exit 1
fi

echo "[INFO] enabling ufw"
# check if its active first
ACTIVE=$(sudo ufw status verbose | grep Status | awk '{print $2}')
if [[ "$ACTIVE" != "active" ]]; then
    sudo ufw enable
    error_handle
fi


echo "[INFO] updating ufw rules for docker-swarm communication"
while IFS= read -r line; do
    # specify who can connect
    sudo ufw allow from "$line" to any port 2377 proto tcp
    error_handle
    sudo ufw allow from "$line" to any port 7946 # not specifying proto does both tcp+udp
    error_handle
    sudo ufw allow from "$line" to any port 4789 proto udp
    error_handle
    # specify who can't connect (everyone else)
    sudo ufw deny from any to any port 2377 proto tcp
    error_handle
    sudo ufw deny from any to any port 7946
    error_handle
    sudo ufw deny from any to any port 4789 proto udp
    error_handle
done < "$HOSTS_FILE"

echo "[INFO] finished updating ufw rules for docker-swarm communication"