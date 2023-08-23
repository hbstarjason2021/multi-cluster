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
     INSTALL_K3S_EXEC_="--docker" \
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

###############

kubectl create deploy whoami --image=traefik/whoami --replicas=2

kubectl scale deploy whoami --replicas=5

kubectl expose deploy whoami --port=80
kubectl get svc -owide
kubectl describe svc whoami

# 在本地通过 service 多访问几次，出轮询访问 container
# curl http://<external-ip>:<port>

curl `kubectl get -o template service/whoami --template='{{.spec.clusterIP}}'`

# 自行替换 <PUBLIC_IP> 为当前节点的公网 IP
kubectl expose deploy whoami --type=LoadBalancer --port=80 --external-ip <PUBLIC_IP>

COMMENT
