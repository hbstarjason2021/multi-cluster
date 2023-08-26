
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


### https://docs.cilium.io/en/v1.10/gettingstarted/k8s-install-default/


## cilium install
## cilium status --wait
## cilium connectivity test
## cilium hubble enable --ui
