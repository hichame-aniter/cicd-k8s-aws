# CI/CD inside Kubernetes on AWS
Deploying a kubernetes cluster on aws and a cicd pipeline inside it using terraform, ansible ans bash

## Steps

- Create Kubernetes Cluster
    - Create EC2 instances on AWS using Terraform
    - Configure VMs using Ansible
- Create CI/CD Pipeline

## Prerequisite

1. In your bastion machine install the following:

    - [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) 
    - [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
    - [Kubctl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)

2. Make sure AWS credentials are configured at ~/.aws/credentials

## Deployment

### Infrastructure provisioning

Follow steps in [Terrafom](terraform/README.md)

### Infrastructure configuration

Follow to [Ansible](ansible/README.md)

---
### Run Everything at ounce
I included all commands in a script that you can use 
(**not recommanded unless you know what you doing**)
```bash
./run_all.sh
```