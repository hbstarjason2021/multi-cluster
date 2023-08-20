
### https://submariner.io/getting-started/quickstart/k3s/

### Deploy cluster-a 
POD_CIDR=10.44.0.0/16
SERVICE_CIDR=10.45.0.0/16
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--cluster-cidr $POD_CIDR --service-cidr $SERVICE_CIDR" sh -s -

sudo cp /etc/rancher/k3s/k3s.yaml kubeconfig.cluster-a
sudo chown $(id -u):$(id -g) kubeconfig.cluster-a
export IP=$(hostname -I | awk '{print $1}')
yq -i eval \
'.clusters[].cluster.server |= sub("127.0.0.1", env(IP)) | .contexts[].name = "cluster-a" | .current-context = "cluster-a"' \
kubeconfig.cluster-a

### Deploy cluster-b
POD_CIDR=10.144.0.0/16
SERVICE_CIDR=10.145.0.0/16
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--cluster-cidr $POD_CIDR --service-cidr $SERVICE_CIDR" sh -s -

sudo cp /etc/rancher/k3s/k3s.yaml kubeconfig.cluster-b
sudo chown $(id -u):$(id -g) kubeconfig.cluster-b
export IP=$(hostname -I | awk '{print $1}')
yq -i eval \
'.clusters[].cluster.server |= sub("127.0.0.1", env(IP)) | .contexts[].name = "cluster-b" | .current-context = "cluster-b"' \
kubeconfig.cluster-b

### 
