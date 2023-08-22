
####
curl -O https://raw.githubusercontent.com/spinnaker/halyard/master/install/debian/InstallHalyard.sh && \
    bash InstallHalyard.sh -y  && \
    hal -v 

####
MINIO_ROOT_USER=$(< /dev/urandom tr -dc a-z | head -c${1:-4})
MINIO_ROOT_PASSWORD=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-8})
MINIO_PORT="9010"

# Start the container
docker run -it -d --rm -v ~/.minio-data/:/data --name minio-4-spinnaker -p ${MINIO_PORT}:${MINIO_PORT} \
 -e MINIO_ROOT_USER=${MINIO_ROOT_USER} -e  MINIO_ROOT_PASSWORD=${MINIO_ROOT_PASSWORD} \
 minio/minio  server /data --address :${MINIO_PORT}

echo "
MINIO_ROOT_USER=${MINIO_ROOT_USER}
MINIO_ROOT_PASSWORD=${MINIO_ROOT_PASSWORD}
ENDPOINT=http://$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' minio-4-spinnaker):${MINIO_PORT} "

