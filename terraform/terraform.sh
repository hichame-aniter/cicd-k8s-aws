#!/bin/bash

# Global Variables
TERRAFORM_DIR=$(dirname "$(realpath "$0")")

# Provisioning VMs on aws using terraform

terraform -chdir="$TERRAFORM_DIR" init

terraform -chdir="$TERRAFORM_DIR" apply -auto-approve

# Update Public IP
terraform -chdir="$TERRAFORM_DIR" plan -refresh-only

#Saving Cluster Public IP 

terraform -chdir="$TERRAFORM_DIR" output > $TERRAFORM_DIR/cluster01-ip

