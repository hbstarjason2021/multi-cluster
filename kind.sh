
kind create cluster --name c1 --config kind-cluster-c1.yaml

kubectl cluster-info --context kind-c1

kubectl config use-context kind-c1


cilium clustermesh enable --context kind-c1 \
   --service-type LoadBalancer \
   --create-ca

cilium clustermesh status --context kind-c1 --wait

########################################################################

# kind create cluster --name c2 --config kind-cluster-c2.yaml

## 

cilium clustermesh enable --context kind-c2 \
   --service-type LoadBalancer \
   --create-ca

cilium clustermesh status --context kind-c2 --wait


########################################################################

cilium clustermesh connect --context kind-c1 \
   --destination-context kind-c2

cilium clustermesh status --context kind-c1 --wait


kubectl get svc -A | grep clustermesh

cilium connectivity test --context kind-c1 --multi-cluster kind-c2
