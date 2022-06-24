#!/bin/bash


#######Installing kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

chmod +x ./kubectl

sudo mv ./kubectl /usr/local/bin/kubectl
###Installing K3D
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
k3d
