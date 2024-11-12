# Infrastructure configuration
### Playbooks content
- Update VMs
- Install required packages
- Configure network 
- Configure security

***Make sure you are in ansible directory***
```bash
cd ansible/
```

### Checking Dynamic inventory 
 To list EC2 instances
```bash
ansible-inventory --graph 
```
Outout should be something like:
```bash
[hichame@centos ansible]$ ansible-inventory --graph
@all:
  |--@ungrouped:
  |--@aws_ec2:
  |  |--ec2-3-249-89-249.eu-west-1.compute.amazonaws.com
  |  |--ec2-34-252-25-19.eu-west-1.compute.amazonaws.com
  |  |--ec2-54-170-191-74.eu-west-1.compute.amazonaws.com
  |  |--ec2-3-248-182-42.eu-west-1.compute.amazonaws.com
  |  |--ec2-34-244-9-244.eu-west-1.compute.amazonaws.com
  |--@k8s_cluster01:
  |  |--ec2-3-249-89-249.eu-west-1.compute.amazonaws.com
  |  |--ec2-34-252-25-19.eu-west-1.compute.amazonaws.com
  |  |--ec2-54-170-191-74.eu-west-1.compute.amazonaws.com
  |  |--ec2-3-248-182-42.eu-west-1.compute.amazonaws.com
  |  |--ec2-34-244-9-244.eu-west-1.compute.amazonaws.com
  |--@_Master:
  |  |--ec2-3-249-89-249.eu-west-1.compute.amazonaws.com
  |  |--ec2-34-244-9-244.eu-west-1.compute.amazonaws.com
  |--@_Worker:
  |  |--ec2-34-252-25-19.eu-west-1.compute.amazonaws.com
  |  |--ec2-54-170-191-74.eu-west-1.compute.amazonaws.com
  |--@_LoadBalancer:
  |  |--ec2-3-248-182-42.eu-west-1.compute.amazonaws.com
```

### Praparing files for playbook
#### TLS Certificates
```bash
cd kubernetes/certificates/
./createCertificates.sh
```

### Executing playbook
```bash
cd ../
ansible-playbook playbook.yaml
```
