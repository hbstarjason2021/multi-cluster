####

ROOT_DIR="$(
  cd "$(dirname "$0")" >/dev/null 2>&1 || exit 1
  pwd -P
)"


curl -O https://raw.githubusercontent.com/spinnaker/halyard/master/install/debian/InstallHalyard.sh && \
    bash InstallHalyard.sh -y  && \
    hal -v 

sleep 5

 hal version list    
