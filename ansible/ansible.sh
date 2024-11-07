#!/bin/bash

# Global Variables
ANSIBLE_DIR=$(dirname "$(realpath "$0")")

# Init VMs && Install Containerd

ansible-playbook -i $ANSIBLE_DIR/my_inventory/hosts.aws_ec2.yaml $ANSIBLE_DIR/playbook.yaml --private-key $ANSIBLE_DIR/myKey.pem -u ec2-user

#createCertificates.sh