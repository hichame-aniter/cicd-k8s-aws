#!/bin/bash

# Global Variables

HOME_DIR=$(dirname "$(realpath "$0")")

#Deleting VMs on aws using terraform

terraform -chdir="$HOME_DIR/terraform/" init

terraform -chdir="$HOME_DIR/terraform/" destroy

