#!/bin/bash

# Global Variables

HOME_DIR=$(dirname "$(realpath "$0")")

# Launch Terraform

$HOME_DIR/terraform/terraform.sh

# Securing myKey.pem

chmod 400 $HOME_DIR/ansible/ssh_key.pem

# Create Certificates / Kubeconfig / EncryptionConfig

./kubernetes/createCertificates.sh
./kubernetes/createKubeconfig.sh
./kubernetes/createEncryptionConfig.sh


# Launch Ansible Playbooks

$HOME_DIR/ansible/ansible.sh