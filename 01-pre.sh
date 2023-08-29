#!/bin/bash
set -eux

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

function getLocation() {
    countryCode=$(curl -s "http://ip-api.com/line/?fields=countryCode")
}

###### Install KIND
function install_kind(){

KIND_VERSION="${KIND_VERSION:-v0.20.0}"
## KIND_CLUSTER_VERSION="${KIND_CLUSTER_VERSION:-v1.25.11}"

if [ "$countryCode" == "CN" ]; then
echo -e "检测到国内环境，正在使用镜像下载"
  curl -Lo /usr/bin/kind  https://jihulab.com/hbstarjason/ali-init/-/raw/main/kind-linux-amd64-v0.20.0 && chmod +x /usr/bin/kind
else
  curl -Lo /usr/bin/kind https://kind.sigs.k8s.io/dl/${KIND_VERSION}/kind-linux-amd64 && chmod +x /usr/bin/kind
fi
    
  kind version
}

###### Install Kubectl
function install_kubectl() {

if [ "$countryCode" == "CN" ]; then
echo -e "检测到国内环境，正在使用镜像下载"
  curl -L "https://jihulab.com/hbstarjason/ali-init/-/raw/main/kubectl-v1.27.3" -o /usr/local/bin/kubectl && chmod +x /usr/local/bin/kubectl
else
  curl -L -o /usr/bin/kubectl "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && chmod +x /usr/bin/kubectl
fi

kubectl version --client
}


getLocation

install_kind
install_kubectl



### Install kubecolor
KUBECOLOR_VERSION="0.0.25"
# KUBECOLOR_VERSION=$(curl -s -N https://api.github.com/repos/hidetatz/kubecolor/releases | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/' | head -n 1)

latestURL=$(curl -s https://api.github.com/repos/hidetatz/kubecolor/releases/latest | grep -i "browser_download_url.*${osDistribution}.*${archParam}" | awk -F '"' '{print $4}')

curl -sSL https://github.com/hidetatz/kubecolor/releases/download/v${KUBECOLOR_VERSION}/kubecolor_${KUBECOLOR_VERSION}_Linux_x86_64.tar.gz | sudo tar xz -C /usr/local/bin kubecolor
kubecolor version --client

### Install kubectx
apt install jq -y

KUBECTX_VERSION="v0.9.5"
# KUBECTX_VERSION=$(curl -s https://api.github.com/repos/ahmetb/kubectx/releases | jq -r '.[0].tag_name')
# KUBECTX_VERSION=$(curl -s -N https://api.github.com/repos/ahmetb/kubectx/releases | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/' | head -n 1)

curl -sSL https://github.com/ahmetb/kubectx/releases/download/${KUBECTX_VERSION}/kubectx_${KUBECTX_VERSION}_linux_x86_64.tar.gz | sudo tar xz -C /usr/local/bin kubectx
# curl  https://jihulab.com/hbstarjason/ali-init/-/raw/main/kubectx_v0.9.5_linux_x86_64.tar.gz | sudo tar xz -C /usr/local/bin kubectx

### Install Helm 
curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
# curl -sSL https://jihulab.com/hbstarjason/ali-init/-/raw/main/helm-v3.11.3-linux-amd64.tar.gz | sudo tar xz -C /usr/local/bin --strip-components=1 linux-amd64/helm
helm version 

### Install terraform
TF_VERSION="1.5.6"
curl -LO https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip
unzip terraform_${TF_VERSION}_linux_amd64.zip
mv terraform /usr/local/bin
terraform version   
terraform -install-autocomplete

### Install cilium
### https://docs.cilium.io/en/v1.10/gettingstarted/k8s-install-default/
curl -L --remote-name-all https://github.com/cilium/cilium-cli/releases/latest/download/cilium-linux-amd64.tar.gz{,.sha256sum}
sha256sum --check cilium-linux-amd64.tar.gz.sha256sum
sudo tar xzvfC cilium-linux-amd64.tar.gz /usr/local/bin
rm cilium-linux-amd64.tar.gz{,.sha256sum}
cilium version

