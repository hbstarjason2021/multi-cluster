
### Install KIND
KIND_VESION="v0.20.0"
curl -Lo /usr/bin/kind https://kind.sigs.k8s.io/dl/${KIND_VESION}/kind-linux-amd64 && chmod +x /usr/bin/kind
kind version 

### Install Kubectl 
curl -L -o /usr/bin/kubectl "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && chmod +x /usr/bin/kubectl
kubectl version --client

### Install kubecolor
KUBECOLOR_VERSION=0.0.25
curl -sSL https://github.com/hidetatz/kubecolor/releases/download/v${KUBECOLOR_VERSION}/kubecolor_${KUBECOLOR_VERSION}_Linux_x86_64.tar.gz | sudo tar xz -C /usr/local/bin kubecolor
kubecolor version --client

### Install kubectx
KUBECTX_VERSION=(curl -s https://api.github.com/repos/ahmetb/kubectx/releases | jq -r '.[0].tag_name')
curl -sSL https://github.com/ahmetb/kubectx/releases/download/${KUBECTX_VERSION}/kubectx_${KUBECTX_VERSION}_linux_x86_64.tar.gz | sudo tar xz -C /usr/local/bin kubectx

### Install Helm 
curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
helm version 
