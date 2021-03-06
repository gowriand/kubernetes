#!/bin/bash

sudo cp /etc/hosts /etc/hosts_bak
sudo cp etc/hosts /etc/hosts

##modify some system settings
echo "overlay 
br_netfilter " >> /etc/modules-load.d/containerd.conf 
sudo modprobe overlay 
sudo modprobe br_netfilter 

echo "net.bridge.bridge-nf-call-iptables = 1 
net.ipv4.ip_forward = 1 
net.bridge.bridge-nf-call-ip6tables = 1" >> /etc/sysctl.d/99-kubernetes-cri.conf
sudo sysctl --system

##setup containerd
sudo apt-get update
sudo apt-get install -y containerd 
sudo mkdir -p /etc/containerd 
sudo containerd config default | sudo tee /etc/containerd/config.toml 
sudo systemctl restart containerd

sudo swapoff -a


#install kubeadm, kubelet, and kubectl.

sudo apt-get update  
sudo apt-get install -y apt-transport-https curl 
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - 
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" >> /etc/apt/sources.list.d/kubernetes.list 
sudo apt-get update 
sudo apt-get install -y kubelet=1.23.0-00 kubeadm=1.23.0-00 kubectl=1.23.0-00 
sudo apt-mark hold kubelet kubeadm kubectl

sudo kubeadm init --pod-network-cidr 192.168.0.0/16 --kubernetes-version 1.23.0
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

kubeadm token create --print-join-command
