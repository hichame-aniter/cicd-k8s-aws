#!/bin/bash

# Global Variables

HOME_DIR=$(dirname "$(realpath "$0")")

# Launch Terraform

$HOME_DIR/terraform/terraform.sh

# Securing myKey.pem

chmod 400 $HOME_DIR/ansible/myKey.pem

# Launch Ansible

$HOME_DIR/ansible/ansible.sh