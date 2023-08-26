
### https://metallb.universe.tf/installation/

kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.10/config/manifests/metallb-native.yaml

## FRR mode
## kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.10/config/manifests/metallb-frr.yaml

# wait for MetalLB to be ready
sleep 10
kubectl wait --namespace metallb-system --for=condition=ready pod --selector=app=metallb --timeout=30s



subnet=$(docker network inspect kind | jq -r '.[].IPAM.Config[].Subnet' | grep -P '^(?:[0-9]{1,3}\.){3}[0-9]{1,3}/.*$')


###############
cat <<EOF| kubectl apply -f -
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: default
  namespace: metallb-system
spec:
  addresses:
  - "${start_ip}-${end_ip}"
---
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: empty
  namespace: metallb-system
EOF
