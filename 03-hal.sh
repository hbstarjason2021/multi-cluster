####
curl -O https://raw.githubusercontent.com/spinnaker/halyard/master/install/debian/InstallHalyard.sh && \
    bash InstallHalyard.sh -y  && \
    hal -v 

sleep 5

 hal version list    
