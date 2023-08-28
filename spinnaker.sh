#!/bin/bash
set -eux

export IP=$(ip addr show dev $(ip r | grep default | tr ' ' \\n | grep -A1 dev | tail -n1) | grep 'inet ' | awk '{print $2}' | cut -d/ -f1); echo $IP

#### minio
# MINIO_ROOT_USER=$(< /dev/urandom tr -dc a-z | head -c${1:-4})
# MINIO_ROOT_PASSWORD=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-8})
MINIO_ROOT_USER=minioadmin
MINIO_ROOT_PASSWORD=minioadmin
MINIO_ENCRYPTION_KEY=minio-encryption-key
MINIO_PORT="9010"

# Start minio container
docker pull minio/minio
docker run -it -d --rm -v ~/.minio-data/:/data --name minio-4-spinnaker \
 -p ${MINIO_PORT}:${MINIO_PORT} \
 -p 9011:9011 \
 -e "MINIO_ROOT_USER=${MINIO_ROOT_USER}" \
 -e "MINIO_ROOT_PASSWORD=${MINIO_ROOT_PASSWORD}" \
 -e "MINIO_KMS_SECRET_KEY_FILE=minio-encryption-key:${MINIO_ENCRYPTION_KEY}" \
 minio/minio  server /data --address :${MINIO_PORT}  --console-address '0.0.0.0:9011'


MINIO_ROOT_USER=${MINIO_ROOT_USER}
MINIO_ROOT_PASSWORD=${MINIO_ROOT_PASSWORD}
ENDPOINT=http://$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' minio-4-spinnaker):${MINIO_PORT}

echo "
MINIO_ROOT_USER=${MINIO_ROOT_USER}
MINIO_ROOT_PASSWORD=${MINIO_ROOT_PASSWORD}
ENDPOINT=http://$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' minio-4-spinnaker):${MINIO_PORT} "

## wget http://dl.minio.org.cn/client/mc/release/linux-amd64/mc
## ./mc config host add minio2023 http://172.30.1.2:9010 minioadmin minioadmin
## ./mc config host list
## ./mc mb minio2023/bucket8
## ./mc ls minio22023

## ./mc cp terraform_1.5.2_linux_amd64.zip minio2023/bucket8 


echo ${MINIO_ROOT_PASSWORD} | hal config storage s3 edit \
  --access-key-id ${MINIO_ROOT_USER} \
  --secret-access-key \
  --endpoint ${ENDPOINT}  --no-validate

chmod 777 /root/ && chmod 777 /root/.kube/config

## hal version list
hal config version edit --version 1.30.3

DEPLOYMENT="default"
mkdir -p ~/.hal/$DEPLOYMENT/profiles/
echo spinnaker.s3.versioning: false > ~/.hal/$DEPLOYMENT/profiles/front50-local.yml

hal config storage edit --type s3 --no-validate

hal config provider kubernetes enable
hal config provider kubernetes account add my-k8s-new \
           --provider-version v2 \
           --context $(kubectl config current-context)
hal config deploy edit --type=distributed --account-name my-k8s-new

hal deploy apply 
