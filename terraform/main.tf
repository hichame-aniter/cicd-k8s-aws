resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "aws_key_pair" "kp" {
  key_name = "cicd-k8s-aws-kp"
  public_key = tls_private_key.pk.public_key_openssh
}

resource "local_file" "myKey" {
  filename = "myKey.pem"
  content = tls_private_key.pk.private_key_pem
}

resource "aws_instance" "controlplane01" {
	ami = var.ami
	instance_type = var.instance_type
	key_name = aws_key_pair.kp.key_name
	tags = {
    	Name = "controlplane01" #var.instance_name
  	}
}
resource "aws_ec2_instance_state" "controlplane01" {
  instance_id = aws_instance.controlplane01.id
  state = var.instances_state
}

