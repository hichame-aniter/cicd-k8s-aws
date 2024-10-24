#!/bin/bash

echo "Deleting VMs on aws using terraform:"

terraform -chdir="./terraform" init

terraform -chdir="./terraform" destroy -auto-approve

echo "Remove cluster-ip-list file"

rm cluster-ip-list

