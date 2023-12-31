#!/bin/bash

### https://www.bookstack.cn/read/cilium-1.12-en/b1e3144630f1fde6.md
### curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC='--flannel-backend=none --disable-network-policy' sh -

## https://ysicing.me/posts/how-to-use-cilium-to-replace-k3s-flannel/

set -eux

curl -sfL https://get.k3s.io | sh -s - \
  --docker \
  --flannel-backend none \
  --disable-network-policy \
  --disable "servicelb" \
  --disable "traefik" \
  --disable "metrics-server"

sudo cat /etc/rancher/k3s/k3s.yaml > ~/.kube/config

# update k3s unit file to kill all subprocesses when stopping
# sudo sed -i "s/KillMode=process/KillMode=mixed/g" /etc/systemd/system/k3s.service
# sudo systemctl daemon-reload

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

