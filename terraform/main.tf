# Generate Private Key
resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits = 4096
}
# Create AWS SSH Key
resource "aws_key_pair" "kp" {
  key_name = "cicd-k8s-aws-kp"
  public_key = tls_private_key.pk.public_key_openssh
}
# Save the Key locally
resource "local_file" "myKey" {
  filename = "../ansible/myKey.pem"
  content = tls_private_key.pk.private_key_pem
}
# Create VPC
resource "aws_vpc" "cluster01_vpc" {
  cidr_block = "192.168.56.0/24"
  enable_dns_hostnames = true
  tags = {
    Name = "cluster01_vpc"
    Terraform = "true"
    Project = var.project
    Environment = var.environment
  }
}
# Manage default Route Table
resource "aws_default_route_table" "cluster01_default_rtb" {
  default_route_table_id = aws_vpc.cluster01_vpc.default_route_table_id

  route {
    cidr_block = "192.168.56.0/24"
    gateway_id = "local"
  }
  tags = {
    Name = "cluster01_default_rtb"
    Terraform = "true"
    Project = var.project
    Environment = var.environment
  }
}
# Manage default ACL
resource "aws_default_network_acl" "default" {
  default_network_acl_id = aws_vpc.cluster01_vpc.default_network_acl_id

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  tags = {
    Name = "cluster01_default_acl"
    Terraform = "true"
    Project = var.project
    Environment = var.environment
  }
}
# Create Internet Gateway
resource "aws_internet_gateway" "cluster01_igw" {
 vpc_id = aws_vpc.cluster01_vpc.id
 tags = {
   Name = "cluster01_igw"
 }
}
# Create Public Route table
resource "aws_route_table" "cluster01_public_rtb" {
  vpc_id = aws_vpc.cluster01_vpc.id
  route {
    cidr_block = "192.168.56.0/24"
    gateway_id = "local"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cluster01_igw.id
  }
  tags = {
    Terraform = "true"
    Name = "cluster01_public_rtb"
    Project = var.project
    Environment = var.environment
  }
}
# Create Private Route table
resource "aws_route_table" "cluster01_private_rtb" {
  vpc_id = aws_vpc.cluster01_vpc.id
  route {
    cidr_block = "192.168.56.0/24"
    gateway_id = "local"
  }
  tags = {
    Terraform = "true"
    Name = "cluster01_private_rtb"
    Project = var.project
    Environment = var.environment
  }
}
# Create Subnets
# - Private Subnets
resource "aws_subnet" "cluster01_private_subnets" {
  vpc_id = aws_vpc.cluster01_vpc.id
  count = length(var.private_subnet_cidrs)
  cidr_block = element(var.private_subnet_cidrs, count.index)
  availability_zone = element(var.availability_zones, count.index)
  tags = {
    Name = "cluster01_private_subnet_${count.index + 1}"
    Terraform = "true"
    Project = var.project
    Environment = var.environment
  }
}
# --- Associate RTB with Private VPC Subnet
resource "aws_route_table_association" "private_subnet_asso" {
 count = length(var.private_subnet_cidrs)
 subnet_id = element(aws_subnet.cluster01_private_subnets[*].id, count.index)
 route_table_id = aws_route_table.cluster01_private_rtb.id
}
# - Public Subnets
resource "aws_subnet" "cluster01_public_subnets" {
  vpc_id = aws_vpc.cluster01_vpc.id
  count = length(var.public_subnet_cidrs)
  cidr_block = element(var.public_subnet_cidrs, count.index)
  availability_zone = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "cluster01_public_subnet_${count.index + 1}"
    Terraform = "true"
    Project = var.project
    Environment = var.environment
  }
}
# --- Associate RTB with Public VPC Subnet
resource "aws_route_table_association" "public_subnet_asso" {
 count = length(var.public_subnet_cidrs)
 subnet_id = element(aws_subnet.cluster01_public_subnets[*].id, count.index)
 route_table_id = aws_route_table.cluster01_public_rtb.id
}
# Get Bastion Public IP
data "http" "myip" {
  url = "https://ipv4.icanhazip.com"
}
resource "aws_default_security_group" "cluster01_default_sg" {
  vpc_id = aws_vpc.cluster01_vpc.id

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Allow SSH for Bastion Machine
    ingress {
    protocol = "tcp"
    to_port = 22
    from_port = 22
    cidr_blocks = ["${chomp(data.http.myip.response_body)}/32"]
  }
  tags = {
    Name = "cluster01_default_sg"
    Terraform = "true"
    Project = var.project
    Environment = var.environment
  }
}

# Create EC2 Instances
resource "aws_instance" "controlplane01" {
	ami = var.ami
	instance_type = var.instance_type
	key_name = aws_key_pair.kp.key_name
  subnet_id = aws_subnet.cluster01_public_subnets[0].id #.id
  private_ip = "192.168.56.11"
	tags = {
    	Name = "kubernetes-ha-controlplane01" #var.instance_name      
      Project = var.project
      Environment = var.environment
      Role = "Master"
      Terraform = "true"
  	}
}
# Turn off/on instances
resource "aws_ec2_instance_state" "controlplane01" {
  instance_id = aws_instance.controlplane01.id
  state = var.instances_state
}
