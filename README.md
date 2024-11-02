# cicd-k8s-aws
Deploy a k8s cluster and cicd pipeline using terraform, ansible on aws


Prerequisite:

In bastion machine install the following:

Terraform 
Ansible
Kubctl

Option 1:
Using run_all.sh (not recommanded unless you know what you are doing)

If [text](cluster-ip-list) is empty run:

terraform apply

terraform output > cluster-ip-list

Option 2:
Executing commands manually 

First: Infrastructure provisioning:

Go to ./terrafom/README.md

Second: Infrastructure initialization

Go to ./ansible/README.md

