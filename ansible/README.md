Make sure AWS credential is configured at ~/.aws/credentials

Get VMs dns names list 

ansible-inventory --graph 

this command should return all machines created with Terraform

Update VMs

ansible-playbook playbook.yaml