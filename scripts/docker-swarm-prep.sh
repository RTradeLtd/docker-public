#! /bin/bash

# prepares a host for docker swarm usage by making access to the ports more restricted
# explanation of port numbers
# 2377/tcp (secure client to daemon communication)
# 7946/tcp+udp (control plane gossip)
# 4789/udp (VXLAN-based overlay networks)

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

# $1 of this is the first paramter passed in
# to call: manager_ports_allow "192.168.1.2"
function update_ports_allowed() {
    sudo ufw allow insert 1 from "$1" to any port 2377 proto tcp
    sudo ufw allow insert 1 from "$1" to any port 7946 proto tcp
    sudo ufw allow insert 1 from "$1" to any port 7946 proto udp
    sudo ufw allow insert 1 from "$1" to any port 4789 proto udp
}

echo "[INFO] updating ufw rules for docker-swarm communication"
while IFS= read -r line; do
    update_ports_allowed "$line"
done < "$HOSTS_FILE"
echo "[INFO] finished updating ufw rules for docker-swarm communication"