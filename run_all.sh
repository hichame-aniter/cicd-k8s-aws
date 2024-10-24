#!/bin/bash

echo "Provisioning VMs  on aws using terraform:"

terraform -chdir="./terraform" init

terraform -chdir="./terraform" apply -auto-approve

echo "Saving Public IP addresses in cluster-ip-list file"

terraform -chdir="./terraform" output > cluster-ip-list

echo "Securing myKey.pem"

chmod 400 terraform/myKey.pem

