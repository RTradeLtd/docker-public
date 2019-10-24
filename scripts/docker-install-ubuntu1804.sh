#! /bin/bash

# installs docker on ubuntu 18.04
# taken from https://www.linode.com/docs/applications/containers/install-docker-ce-ubuntu-1804/
function error_handle() {
    if [[ "$?" != 0 ]]; then
        echo "[ERROR] the last command failed, see logs for details"
        exit 1
    fi
}
echo "[INFO] removing old docker installations"
sudo apt remove docker docker-engine docker.io -y
error_handle
echo "[INFO] setting up dependencies"
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
error_handle
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
error_handle
sudo apt-key fingerprint 0EBFCD88
error_handle
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
error_handle
sudo apt update -y
error_handle
echo "[INFO] installing docker-ce (community edition)"
sudo apt install docker-ce -y
error_handle
sudo usermod -aG docker $USER
error_handle
echo "[INFO] finished installing docker-ce"
