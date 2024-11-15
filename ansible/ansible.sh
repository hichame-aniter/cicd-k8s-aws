#!/bin/bash

# Global Variables
ANSIBLE_DIR=$(dirname "$(realpath "$0")")

# Init VMs && Install Packages

ansible-playbook -i $ANSIBLE_DIR/my_inventory/hosts.aws_ec2.yaml $ANSIBLE_DIR/init_playbook.yaml --private-key $ANSIBLE_DIR/ssh_key.pem -u ec2-user --ssh-extra-args='-o StrictHostKeyChecking=no'

# Create Certificates

#createCertificates.sh

# Copy certificates Nodes 

ansible-playbook -i $ANSIBLE_DIR/my_inventory/hosts.aws_ec2.yaml $ANSIBLE_DIR/cp_certs_playbook.yaml --private-key $ANSIBLE_DIR/ssh_key.pem -u ec2-user --ssh-extra-args='-o StrictHostKeyChecking=no'

# 