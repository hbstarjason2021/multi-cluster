
### https://metallb.universe.tf/installation/

kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.10/config/manifests/metallb-native.yaml

## FRR mode
## kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.10/config/manifests/metallb-frr.yaml

# wait for MetalLB to be ready
sleep 10
kubectl wait --namespace metallb-system --for=condition=ready pod --selector=app=metallb --timeout=30s


# setup MetalLB IP address pool
# Get the subnet from Docker
subnet=$(docker network inspect kind | jq -r '.[].IPAM.Config[].Subnet' | grep -P '^(?:[0-9]{1,3}\.){3}[0-9]{1,3}/.*$')

# Split the subnet into the base IP and the CIDR suffix
IFS='/' read -r ip cidr <<< "$subnet"

# Convert the base IP to a 32-bit integer
IFS='.' read -r i1 i2 i3 i4 <<< "$ip"
ip_dec=$(( (i1<<24) + (i2<<16) + (i3<<8) + i4 ))

# Calculate the number of hosts
num_hosts=$(( 2 ** (32 - cidr) ))

# Calculate the start and end IPs for the second half
start_ip_dec=$(( ip_dec + num_hosts / 2 ))
end_ip_dec=$(( ip_dec + num_hosts - 1 ))

# Convert the start and end IPs back to dotted decimal format
start_ip=$(printf "%d.%d.%d.%d" $(( (start_ip_dec & 0xFF000000) >> 24 )) $(( (start_ip_dec & 0x00FF0000) >> 16 )) $(( (start_ip_dec & 0x0000FF00) >> 8 )) $(( start_ip_dec & 0x000000FF )))
end_ip=$(printf "%d.%d.%d.%d" $(( (end_ip_dec & 0xFF000000) >> 24 )) $(( (end_ip_dec & 0x00FF0000) >> 16 )) $(( (end_ip_dec & 0x0000FF00) >> 8 )) $(( end_ip_dec & 0x000000FF )))

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
