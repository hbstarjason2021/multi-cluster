#curl -sfL https://get.k3s.io | sh -
#curl -sfL https://get.k3s.io  | INSTALL_K3S_VERSION=v1.17.3 sh -
#curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC_="--docker"  sh -s -

curl -sfL https://get.k3s.io | sh -s - --disable=traefik
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

k3s check-config

mkdir -p ~/.kube 
cp /etc/rancher/k3s/k3s.yaml  ~/.kube/config
kubectl get node 


########################### ### 国内安装k3s
:<<COMMENT

#curl -sfL http://rancher-mirror.cnrancher.com/k3s/k3s-install.sh | INSTALL_K3S_MIRROR=cn sh -


curl –sfL \
     https://rancher-mirror.oss-cn-beijing.aliyuncs.com/k3s/k3s-install.sh | \
     INSTALL_K3S_MIRROR=cn sh -s - \
     --system-default-registry "registry.cn-hangzhou.aliyuncs.com" \
     --write-kubeconfig ~/.kube/config \
     --write-kubeconfig-mode 666 \
     --disable traefik


cat > /etc/rancher/k3s/registries.yaml <<EOF
mirrors:
  docker.io:
    endpoint:
      - "http://hub-mirror.c.163.com"
      - "https://docker.mirrors.ustc.edu.cn"
      - "https://registry.docker-cn.com"
EOF

systemctl restart k3s

crictl info |grep mirrors -h5

COMMENT
