#!/bin/bash
set -eux

########   bash <(curl -Ls https://ghproxy.com/https://raw.githubusercontent.com/hbstarjason2021/multi-cluster/main/01-pre.sh)
########   bash <(curl -Ls https://raw.githubusercontent.com/hbstarjason2021/multi-cluster/main/01-pre.sh)


DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

# Find a suitable install location
for CANDIDATE in "$HOME/bin" "/usr/local/bin" "/usr/bin"; do
  if [[ -w $CANDIDATE ]] && grep -q "$CANDIDATE" <<<"$PATH"; then
    TARGET_DIR="$CANDIDATE"
    break
  fi
done

ARCH=$(uname -m | sed -e 's/x86_64/amd64/' -e 's/aarch64/arm64/')

function getLocation() {
    countryCode=$(curl -s "http://ip-api.com/line/?fields=countryCode")
}

###### Install KIND
function install_kind(){

KIND_VERSION="${KIND_VERSION:-v0.20.0}"
## KIND_CLUSTER_VERSION="${KIND_CLUSTER_VERSION:-v1.25.11}"

if [ "$countryCode" == "CN" ]; then
echo -e "检测到国内环境，正在使用镜像下载kind"
  curl -Lo /usr/bin/kind  https://jihulab.com/hbstarjason/ali-init/-/raw/main/kind-linux-amd64-v0.20.0 && chmod +x /usr/bin/kind
else
  ## curl -Lo /usr/bin/kind https://kind.sigs.k8s.io/dl/${KIND_VERSION}/kind-linux-amd64 && chmod +x /usr/bin/kind
  curl --fail --progress-bar --location "https://kind.sigs.k8s.io/dl/${KIND_VERSION}/kind-linux-${ARCH}" --output "${TARGET_DIR}/kind"
  chmod a+rx "${TARGET_DIR}/kind"
fi
    
  kind version
}

###### Install Kubectl
function install_kubectl() {

if [ "$countryCode" == "CN" ]; then
echo -e "检测到国内环境，正在使用镜像下载kubectl"
  curl -L "https://jihulab.com/hbstarjason/ali-init/-/raw/main/kubectl-v1.27.3" -o /usr/local/bin/kubectl && chmod +x /usr/local/bin/kubectl
else
  curl -L -o /usr/bin/kubectl "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && chmod +x /usr/bin/kubectl
fi

kubectl version --client
}

###### Install Kubectx
function install_kubectx() {
## apt install jq -y

KUBECTX_VERSION="v0.9.5"
# KUBECTX_VERSION=$(curl -s https://api.github.com/repos/ahmetb/kubectx/releases | jq -r '.[0].tag_name')
# KUBECTX_VERSION=$(curl -s -N https://api.github.com/repos/ahmetb/kubectx/releases | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/' | head -n 1)

if [ "$countryCode" == "CN" ]; then
echo -e "检测到国内环境，正在使用镜像下载Kubectx"
  curl  https://jihulab.com/hbstarjason/ali-init/-/raw/main/kubectx_v0.9.5_linux_x86_64.tar.gz | sudo tar xz -C /usr/local/bin kubectx
else
  curl -sSL https://github.com/ahmetb/kubectx/releases/download/${KUBECTX_VERSION}/kubectx_${KUBECTX_VERSION}_linux_x86_64.tar.gz | sudo tar xz -C /usr/local/bin kubectx
fi

}

### Install kubecolor
function install_kubecolor() {
KUBECOLOR_VERSION="0.0.25"
# KUBECOLOR_VERSION=$(curl -s -N https://api.github.com/repos/hidetatz/kubecolor/releases | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/' | head -n 1)
# latestURL=$(curl -s https://api.github.com/repos/hidetatz/kubecolor/releases/latest | grep -i "browser_download_url.*${osDistribution}.*${archParam}" | awk -F '"' '{print $4}')

if [ "$countryCode" == "CN" ]; then
echo -e "检测到国内环境，正在使用镜像下载kubecolor"
  curl https://jihulab.com/hbstarjason/ali-init/-/raw/main/kubecolor_0.0.25_Linux_x86_64.tar.gz | sudo tar xz -C /usr/local/bin kubecolor
else
  curl -sSL https://github.com/hidetatz/kubecolor/releases/download/v${KUBECOLOR_VERSION}/kubecolor_${KUBECOLOR_VERSION}_Linux_x86_64.tar.gz | sudo tar xz -C /usr/local/bin kubecolor
fi

kubecolor version --client

}


### Install Helm 
function install_helm() {

if [ "$countryCode" == "CN" ]; then
echo -e "检测到国内环境，正在使用镜像下载Helm"
  curl -sSL https://jihulab.com/hbstarjason/ali-init/-/raw/main/helm-v3.11.3-linux-amd64.tar.gz | sudo tar xz -C /usr/local/bin --strip-components=1 linux-amd64/helm
else
  curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash  
fi

helm version 
}

### Install terraform
function install_terraform() {
TF_VERSION="1.5.6"
curl -LO https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip
unzip terraform_${TF_VERSION}_linux_amd64.zip
mv terraform /usr/local/bin
terraform version   
terraform -install-autocomplete

}


###### Install nexttrace
## https://mtr.moe/README_zh_CN.html

function install_nexttrace() {

if [ "$countryCode" == "CN" ]; then
echo -e "检测到国内环境，正在使用镜像下载nexttrace"
  bash <(curl -Ls https://ghproxy.com/https://raw.githubusercontent.com/sjlleo/nexttrace/main/nt_install.sh)
else
  bash <(curl -Ls https://raw.githubusercontent.com/sjlleo/nexttrace/main/nt_install.sh)
fi

}

getLocation

install_kind
install_kubectl
install_kubectx
install_kubecolor
install_helm

install_nexttrace


### Install cilium
### https://docs.cilium.io/en/v1.10/gettingstarted/k8s-install-default/
curl -L --remote-name-all https://github.com/cilium/cilium-cli/releases/latest/download/cilium-linux-amd64.tar.gz{,.sha256sum}
sha256sum --check cilium-linux-amd64.tar.gz.sha256sum
sudo tar xzvfC cilium-linux-amd64.tar.gz /usr/local/bin
rm cilium-linux-amd64.tar.gz{,.sha256sum}
# cilium version


install_terraform
