#!/bin/bash

set -eux

curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC='--flannel-backend=none --no-flannel' sh -s - \
  --disable-network-policy \
  --disable "servicelb" \
  --disable "traefik" \
  --disable "metrics-server"

sudo cat /etc/rancher/k3s/k3s.yaml > ~/.kube/config

## kubectl create -f https://raw.githubusercontent.com/cilium/cilium/v1.7/install/kubernetes/quick-install.yaml

helm repo add cilium https://helm.cilium.io/

helm install cilium cilium/cilium --version 1.14.1 \
   --namespace kube-system \
   --set nodeinit.enabled=true \
   --set kubeProxyReplacement=partial \
   --set hostServices.enabled=false \
   --set externalIPs.enabled=true \
   --set nodePort.enabled=true \
   --set hostPort.enabled=true \
   --set cluster.name=c1 \
   --set cluster.id=1
