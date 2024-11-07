# Global
project = "cluster01"
environment = "dev"

# EC2
controlplane_list = ["192.168.56.11", "192.168.56.12"]
node_list = ["192.168.56.21"]

ami = "ami-07d4917b6f95f5c2a" #RHEL 9
instance_type = "t2.micro"
instances_state = "running" #[running|stopped]

#VPC
public_subnet_cidrs = ["192.168.56.0/26"]#, "192.168.56.64/26"]
availability_zones = ["eu-west-1a"]#, "eu-west-1b", "eu-west-1c"]

private_subnet_cidrs = []#"192.168.56.128/26", "192.168.56.192/26"]