#!/bin/bash

# Global Variables
TERRAFORM_DIR=$(dirname "$(realpath "$0")")

# Provisioning VMs on aws using terraform

terraform -chdir="$TERRAFORM_DIR" init

terraform -chdir="$TERRAFORM_DIR" apply -auto-approve

#Saving Public IP addresses in cluster-ip-list file
#terraform -chdir="./terraform" output > cluster-ip-list
